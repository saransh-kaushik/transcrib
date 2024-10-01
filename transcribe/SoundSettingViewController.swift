//
//  SoundSettingViewController.swift
//  transcribe
//
//  Created by Hompushparaj Mehta on 01/10/24.
//

import UIKit

class SoundSettingViewController: UIViewController {

    let customTintColor = UIColor(hex: "#FF6026")

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sound Settings"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let soundEffectsLabel: UILabel = {
        let label = UILabel()
        label.text = "Sound Effects"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let soundEffectsSwitch: UISwitch = {
        let soundEffectsSwitch = UISwitch()
        soundEffectsSwitch.isOn = true
        soundEffectsSwitch.translatesAutoresizingMaskIntoConstraints = false
        return soundEffectsSwitch
    }()
    
    let volumeLabel: UILabel = {
        let label = UILabel()
        label.text = "Volume"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50 // Default volume
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Settings", for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor(hex: "#FF6026")
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveSettingsTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        // Add views to the main view
        view.addSubview(titleLabel)
        view.addSubview(soundEffectsLabel)
        view.addSubview(soundEffectsSwitch)
        view.addSubview(volumeLabel)
        view.addSubview(volumeSlider)
        view.addSubview(saveButton)

        // Constraints for title label
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        // Constraints for sound effects label
        NSLayoutConstraint.activate([
            soundEffectsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            soundEffectsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        // Constraints for sound effects switch
        NSLayoutConstraint.activate([
            soundEffectsSwitch.centerYAnchor.constraint(equalTo: soundEffectsLabel.centerYAnchor),
            soundEffectsSwitch.leadingAnchor.constraint(equalTo: soundEffectsLabel.trailingAnchor, constant: 10)
        ])
        
        // Constraints for volume label
        NSLayoutConstraint.activate([
            volumeLabel.topAnchor.constraint(equalTo: soundEffectsLabel.bottomAnchor, constant: 40),
            volumeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        // Constraints for volume slider
        NSLayoutConstraint.activate([
            volumeSlider.topAnchor.constraint(equalTo: volumeLabel.bottomAnchor, constant: 20),
            volumeSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            volumeSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Constraints for save button
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: volumeSlider.bottomAnchor, constant: 40),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc func saveSettingsTapped() {
        let volume = volumeSlider.value
        let soundEffectsEnabled = soundEffectsSwitch.isOn
        
        // Save settings logic (e.g., updating global variables or UserDefaults)
        print("Settings Saved: Volume - \(volume), Sound Effects - \(soundEffectsEnabled)")
        
        // Provide feedback to user
        let alert = UIAlertController(title: "Settings Saved", message: "Your sound settings have been saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
