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
                // Update the liveTranscriptionAreaTextView with the latest transcription result
                self.liveTranscriptionAreaTextView.text = result.bestTranscription.formattedString
                
                // Enable buttons when transcription is available
                self.textSaveButton.isEnabled = true
                self.textEditButton.isEnabled = true
                self.shareButton.isEnabled = true
            }
            
            if error != nil || result?.isFinal == true {
                self.stopRecording()
            }
        }
        
        // Configure audio engine
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
        guard let text = liveTranscriptionAreaTextView.text, !text.isEmpty else { return }
        // Save the text to a file (example saving logic, you can adapt to your needs)
        let fileName = "TranscribedText.txt"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            do {
                try text.write(to: fileURL, atomically: true, encoding: .utf8)
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
        guard let text = liveTranscriptionAreaTextView.text else { return }
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)

    }
    
}
