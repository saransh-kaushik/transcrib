//
//  SpeechToTextViewController.swift
//  transcribe
//
//  Created by Hompushparaj Mehta on 30/09/24.
//
// Speech to Text (STT)
import UIKit
import Speech
import AVFoundation

class SpeechToTextViewController: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var textEditButton: UIButton!
    @IBOutlet weak var textSaveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var liveTranscriptionAreaTextView: UITextView!

    let currentLanguage = AppSettings.shared.selectedLanguage
    private lazy var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: currentLanguage))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    override func viewDidLoad() {
        super.viewDidLoad()

        liveTranscriptionAreaTextView.layer.borderColor = UIColor.black.cgColor
        liveTranscriptionAreaTextView.layer.borderWidth = 1
        liveTranscriptionAreaTextView.layer.cornerRadius = 10
        liveTranscriptionAreaTextView.clipsToBounds = true
        liveTranscriptionAreaTextView.isEditable = false

        textSaveButton.isEnabled = false
        textEditButton.isEnabled = false
        shareButton.isEnabled = false

        speechRecognizer?.delegate = self
        requestSpeechAuthorization()
    }

    private func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.startBtn.isEnabled = true
                case .denied, .restricted, .notDetermined:
                    self.startBtn.isEnabled = false
                    self.liveTranscriptionAreaTextView.text = "Speech recognition not available"
                @unknown default:
                    fatalError()
                }
            }
        }
    }

    @IBAction func startTranscription(_ sender: Any) {
        if audioEngine.isRunning {
            stopRecording()
            startBtn.setTitle("Start", for: .normal)
        } else {
            startRecording()
            startBtn.setTitle("Stop", for: .normal)
        }
    }

    private func startRecording() {
        // Reset task and audio session
        resetRecognitionTask()

        // Clear the text view for new transcription
        liveTranscriptionAreaTextView.text = ""

        // Ensure that speech recognizer is available
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            liveTranscriptionAreaTextView.text = "Speech recognizer not available"
            return
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create a recognition request")
        }

        recognitionRequest.shouldReportPartialResults = true

        // Setup the recognition task
        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                let newTranscription = result.bestTranscription.formattedString
                self.liveTranscriptionAreaTextView.text = newTranscription

                // Enable buttons when transcription is available
                self.textSaveButton.isEnabled = true
                self.textEditButton.isEnabled = true
                self.shareButton.isEnabled = true
            }

            // Stop recognition if an error occurs or the transcription finishes
            if error != nil || result?.isFinal == true {
                self.stopRecording()
            }
        }

        // Start the audio engine
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                self.recognitionRequest?.append(buffer)
            }

            audioEngine.prepare()
            try audioEngine.start()
            liveTranscriptionAreaTextView.text = "Listening..."
        } catch {
            print("Audio engine couldn't start due to error: \(error.localizedDescription)")
        }
    }

    private func stopRecording() {
        // Stop and reset the audio engine
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)

        // End the recognition request and cancel the task
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
    }

    private func resetRecognitionTask() {
        // Stop the audio engine and recognition task cleanly
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }

        // Ensure the audio engine is stopped and input taps are removed
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }

        recognitionRequest = nil
    }

    @IBAction func saveText(_ sender: UIButton) {
        guard let transcription = liveTranscriptionAreaTextView.text, !transcription.isEmpty else { return }
        // Save the transcribed text to a file
        let fileName = generateFileName()
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            do {
                try transcription.write(to: fileURL, atomically: true, encoding: .utf8)
                print("File saved at: \(fileURL)")
            } catch {
                print("Error saving file: \(error)")
            }
        }
    }
    
    func generateFileName() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let currentDate = Date()
        let timeStamp = dateFormatter.string(from: currentDate)
        let fileName = "TranscribedText_\(timeStamp).txt"
        
        return fileName
    }


    @IBAction func editText(_ sender: UIButton) {
        liveTranscriptionAreaTextView.isEditable = true
        liveTranscriptionAreaTextView.becomeFirstResponder()
    }

    @IBAction func shareText(_ sender: Any) {
        guard let transcription = liveTranscriptionAreaTextView.text, !transcription.isEmpty else { return }
        let activityViewController = UIActivityViewController(activityItems: [transcription], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }

    // Cleanup tasks when view disappears to prevent app crashes
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if audioEngine.isRunning {
            stopRecording()
        }
    }

    // Ensure proper cleanup on app termination
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        if audioEngine.isRunning {
            stopRecording()
        }
    }
}
