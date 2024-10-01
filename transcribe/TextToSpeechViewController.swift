//
//  TextToSpeechViewController.swift
//  transcribe
//
//  Created by Hompushparaj Mehta on 30/09/24.
//

import UIKit
import AVFoundation

class TextToSpeechViewController: UIViewController, UITextViewDelegate, AVSpeechSynthesizerDelegate {
    
    struct AudioAction: Codable {
        let titleLabel: String
        let subTitleLabel: String
        let timestampLabel: String
        let playIcon: String
        let audioPath: String
    }
    
    var actions = [AudioAction]()
    let speechSynthesizer = AVSpeechSynthesizer()
    let currentLanguage = AppSettings.shared.selectedLanguage
    var isSpeaking = false // Track if speech is currently playing
    var speechUtterance: AVSpeechUtterance? // Store the current utterance
    var recorder: AVAudioRecorder?
    
    @IBOutlet weak var TextInputTextView: UITextView!
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var clearTextBox: UIButton!
    @IBOutlet weak var SaveAudio: UIButton!
    
    let placeholderText = "Enter your text here....."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextView()
        setupActions()
        speechSynthesizer.delegate = self // Set the delegate here
    }
    
    private func setupTextView() {
        TextInputTextView.layer.borderColor = UIColor.black.cgColor
        TextInputTextView.layer.borderWidth = 1
        TextInputTextView.layer.cornerRadius = 10
        TextInputTextView.clipsToBounds = true
        
        TextInputTextView.text = placeholderText
        TextInputTextView.textColor = .lightGray
        TextInputTextView.delegate = self
    }
    
    private func setupActions() {
        play.addTarget(self, action: #selector(togglePlayPause), for: .touchUpInside)
        clearTextBox.addTarget(self, action: #selector(clearText), for:.touchUpInside )
        SaveAudio.addTarget(self, action: #selector(saveAudioToFile), for: .touchUpInside)
    }
    
    @objc func togglePlayPause() {
        guard !TextInputTextView.text.isEmpty && TextInputTextView.text != placeholderText else {
            showAlert("Input required", "Please enter some text to speak.")
            return
        }
        
        if isSpeaking {
            pauseSpeech()
        } else if speechSynthesizer.isSpeaking {
            resumeSpeech()
        } else {
            speakText()
        }
    }
    
    // TextView placeholder management
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
        }
    }
    
    @objc func speakText() {
        guard !TextInputTextView.text.isEmpty && TextInputTextView.text != placeholderText else {
            showAlert("Input required", "Please enter some text to speak.")
            return
        }
        
        speechUtterance = AVSpeechUtterance(string: TextInputTextView.text)

        // Get the selected voice, speech speed, and pitch from AppSettings
        let speechSpeed = AppSettings.shared.speechSpeed
        let pitch = AppSettings.shared.pitch

        // Apply the speech speed and pitch from settings
        speechUtterance?.voice = AVSpeechSynthesisVoice(language: currentLanguage)
        speechUtterance?.rate = speechSpeed // Set the speech rate (speed)
        speechUtterance?.pitchMultiplier = pitch // Set the pitch multiplier
        
        speechSynthesizer.speak(speechUtterance!)
        isSpeaking = true
        play.setTitle("Pause", for: .normal)
    }

    func pauseSpeech() {
        if isSpeaking {
            speechSynthesizer.pauseSpeaking(at: .immediate)
            play.setTitle("Resume", for: .normal) // Change button title to "Resume"
            isSpeaking = false
        }
    }

    func resumeSpeech() {
        if !isSpeaking {
            speechSynthesizer.continueSpeaking()
            play.setTitle("Pause", for: .normal) // Change button title to "Pause"
            isSpeaking = true
        }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        isSpeaking = false
        play.setTitle("Resume", for: .normal) // Change button title to "Resume"
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        isSpeaking = true
        play.setTitle("Pause", for: .normal) // Change button title to "Pause"
    }
    
    // Clear text
    @objc func clearText() {
        TextInputTextView.text = ""
        
        speechSynthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
        play.setTitle("Play", for: .normal)
    }
    
    // save audio
    @objc func saveAudioToFile() {
        guard !TextInputTextView.text.isEmpty && TextInputTextView.text != placeholderText else {
            showAlert("Input required", "Please enter some text to save as audio.")
            return
        }

        // Get current timestamp for file name
        let timestamp = Int(Date().timeIntervalSince1970)
        let fileName = "\(timestamp)_output.m4a" // Save as .m4a
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)

        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC, // AAC format
            AVSampleRateKey: 44100, // Sample rate (common for audio)
            AVNumberOfChannelsKey: 1, // Mono audio
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue // High audio quality
        ]

        do {
            // Create an audio recorder instance
            recorder = try AVAudioRecorder(url: filePath, settings: settings)
            recorder?.record()
            
            print("Recording started...") // Print when recording starts
            
            // Synthesize speech to save audio (without auto-playing)
            let speechUtterance = AVSpeechUtterance(string: TextInputTextView.text)
            speechUtterance.voice = AVSpeechSynthesisVoice(language: currentLanguage)
            speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
            
            // Set delegate to stop recording after speech has finished
            speechSynthesizer.speak(speechUtterance)

        } catch {
            showAlert("Error", "Failed to save audio: \(error.localizedDescription)")
        }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        isSpeaking = false
        play.setTitle("Play", for: .normal)
        
        // Stop recording when speech is finished
        recorder?.stop()
        print("Recording completed.") // Print when recording completes
        
        // Create a new AudioAction and append it to the array
        let newAction = AudioAction(
            titleLabel: "Text to Speech",
            subTitleLabel: getShortenedText(from: TextInputTextView.text),
            timestampLabel: getCurrentTimestamp(),
            playIcon: "play.circle",
            audioPath: recorder?.url.path ?? "" // Use filePath.path for local file URL
        )

        actions.append(newAction)

        // Save actions to JSON
        saveActionsToJSONFile(actions: actions)

        // Show success alert
        showAlert("Success", "Audio saved successfully at \(recorder?.url.lastPathComponent ?? "unknown file").")
    }


    // Utility methods
    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func getShortenedText(from text: String, maxLength: Int = 30) -> String {
        if text.count > maxLength {
            let endIndex = text.index(text.startIndex, offsetBy: maxLength)
            return String(text[..<endIndex]) + "..."
        }
        return text
    }

    func getCurrentTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd h:mm a" // Example format: 2024-09-30 2:00 PM
        return dateFormatter.string(from: Date())
    }

    func saveActionsToJSONFile(actions: [AudioAction]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // Makes the JSON readable
        do {
            let jsonData = try encoder.encode(actions)
            let jsonFilePath = getDocumentsDirectory().appendingPathComponent("audioActions.json")
            try jsonData.write(to: jsonFilePath, options: .atomic)
            print("Actions saved to \(jsonFilePath)")
        } catch {
            print("Error saving actions to JSON: \(error.localizedDescription)")
        }
    }
}
