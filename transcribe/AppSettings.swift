//
//  AppSettings.swift
//  transcribe
//
//  Created by Hompushparaj Mehta on 01/10/24.
//

import Foundation

class AppSettings {
    static let shared = AppSettings()
    
    // Default language is English ("en-US")
    var selectedLanguage: String = "en-US"
    var selectedVoice: String = "Male" // Default voice preference
    var speechSpeed: Float = 1.0 // Default speech speed (normal speed)
    var pitch: Float = 1.0 // Default pitch (normal pitch)
    
    private init() {
        // Load saved preferences from UserDefaults, if available
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
            selectedLanguage = savedLanguage
        }
        if let savedVoice = UserDefaults.standard.string(forKey: "selectedVoice") {
            selectedVoice = savedVoice
        }
        speechSpeed = UserDefaults.standard.float(forKey: "speechSpeed")
        pitch = UserDefaults.standard.float(forKey: "pitch")
        
        // Ensure defaults for sliders are set if values are not stored
        if speechSpeed == 0 {
            speechSpeed = 1.0
        }
        if pitch == 0 {
            pitch = 1.0
        }
    }
    
    // Update language preference
    func updateLanguage(to languageCode: String) {
        selectedLanguage = languageCode
        // Save the updated value to UserDefaults
        UserDefaults.standard.set(languageCode, forKey: "selectedLanguage")
    }
    
    func updateVoicePreference(to voice: String, speed: Float, pitch: Float) {
           selectedVoice = voice
           speechSpeed = speed
           self.pitch = pitch
           
           // Save preferences to UserDefaults
           UserDefaults.standard.set(selectedVoice, forKey: "selectedVoice")
           UserDefaults.standard.set(speechSpeed, forKey: "speechSpeed")
           UserDefaults.standard.set(self.pitch, forKey: "pitch")
       }
}
