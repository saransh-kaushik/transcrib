//
//  SpeechToTextViewController.swift
//  transcribe
//
//  Created by Hompushparaj Mehta on 30/09/24.
//

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
    private var fullTranscription: String = ""  // Holds the final transcription

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
        // Check if speech recognizer is available
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            liveTranscriptionAreaTextView.text = "Speech recognizer not available"
            return
        }

        // Reset task and audio session
        recognitionTask?.cancel()
        recognitionTask = nil

        // Create audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session error: \(error.localizedDescription)")
            return
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Could not create recognition request")
        }

        recognitionRequest.shouldReportPartialResults = true

        // Start recognizing speech
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                // Get the current transcription and update it dynamically
                let newTranscription = result.bestTranscription.formattedString
                self.liveTranscriptionAreaTextView.text = self.fullTranscription + " " + newTranscription

                // Enable buttons when transcription is available
                self.textSaveButton.isEnabled = true
                self.textEditButton.isEnabled = true
                self.shareButton.isEnabled = true

                // When the result is final, update the fullTranscription
                if result.isFinal {
                    self.fullTranscription += " " + newTranscription
                }
            }

            // Stop recognition on error or when speech ends
            if error != nil || result?.isFinal == true {
                self.stopRecording()
            }
        }

        // Configure the audio engine
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
            self.recognitionRequest?.append(buffer)
        }

        // Start the audio engine
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Audio engine couldn't start: \(error.localizedDescription)")
        }

        liveTranscriptionAreaTextView.text = "Listening..."
    }

    private func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        startBtn.setTitle("Start", for: .normal)
    }

    @IBAction func saveText(_ sender: UIButton) {
        guard !fullTranscription.isEmpty else { return }
        // Save the transcribed text to a file
        let fileName = "TranscribedText.txt"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            do {
                try fullTranscription.write(to: fileURL, atomically: true, encoding: .utf8)
                print("File saved at: \(fileURL)")
            } catch {
                print("Error saving file: \(error)")
            }
        }
    }

    @IBAction func editText(_ sender: UIButton) {
        liveTranscriptionAreaTextView.isEditable = true
        liveTranscriptionAreaTextView.becomeFirstResponder()
    }

    @IBAction func shareText(_ sender: Any) {
        guard !fullTranscription.isEmpty else { return }
        let activityViewController = UIActivityViewController(activityItems: [fullTranscription], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }

}

