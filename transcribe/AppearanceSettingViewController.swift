//
//  AppearanceSettingViewController.swift
//  transcribe
//
//  Created by Hompushparaj Mehta on 01/10/24.
//

import UIKit

class AppearanceSettingViewController: UIViewController {

    let customTintColor = UIColor(hex: "#FF6026")
    
    let themeLabel: UILabel = {
        let label = UILabel()
        label.text = "Theme"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lightThemeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Light", for: .normal)
        button.backgroundColor = .lightGray
        button.tintColor = UIColor(hex: "#FF6026")
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(AppearanceSettingViewController.self, action: #selector(themeButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    let darkThemeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dark", for: .normal)
        button.backgroundColor = .darkGray
        button.tintColor = UIColor(hex: "#FF6026")
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(AppearanceSettingViewController.self, action: #selector(themeButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    let fontSizeLabel: UILabel = {
        let label = UILabel()
        label.text = "Font Size"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let fontSizeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 12
        slider.maximumValue = 30
        slider.value = 16 // Default font size
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = UIColor(hex: "#FF6026")
        return slider
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Settings", for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor(hex: "#FF6026")
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(AppearanceSettingViewController.self, action: #selector(saveSettingsTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Appearance Settings"
        setupUI()
    }

    private func setupUI() {
        // Add views to the main view
        view.addSubview(themeLabel)
        view.addSubview(lightThemeButton)
        view.addSubview(darkThemeButton)
        view.addSubview(fontSizeLabel)
        view.addSubview(fontSizeSlider)
        view.addSubview(saveButton)

        // Constraints for theme label
        NSLayoutConstraint.activate([
            themeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            themeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20) // Adjusted top constraint
        ])
        
        // Constraints for light theme button
        NSLayoutConstraint.activate([
            lightThemeButton.topAnchor.constraint(equalTo: themeLabel.bottomAnchor, constant: 20),
            lightThemeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lightThemeButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        // Constraints for dark theme button
        NSLayoutConstraint.activate([
            darkThemeButton.topAnchor.constraint(equalTo: themeLabel.bottomAnchor, constant: 20),
            darkThemeButton.leadingAnchor.constraint(equalTo: lightThemeButton.trailingAnchor, constant: 20),
            darkThemeButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        // Constraints for font size label
        NSLayoutConstraint.activate([
            fontSizeLabel.topAnchor.constraint(equalTo: lightThemeButton.bottomAnchor, constant: 40),
            fontSizeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        // Constraints for font size slider
        NSLayoutConstraint.activate([
            fontSizeSlider.topAnchor.constraint(equalTo: fontSizeLabel.bottomAnchor, constant: 20),
            fontSizeSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fontSizeSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Constraints for save button
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: fontSizeSlider.bottomAnchor, constant: 40),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc func themeButtonTapped(_ sender: UIButton) {
        if sender == lightThemeButton {
            // Change to light theme logic
            view.backgroundColor = .white
            lightThemeButton.backgroundColor = .lightGray
            darkThemeButton.backgroundColor = .darkGray
        } else {
            // Change to dark theme logic
            view.backgroundColor = .black
            lightThemeButton.backgroundColor = .darkGray
            darkThemeButton.backgroundColor = .lightGray
        }
    }

    @objc func saveSettingsTapped() {
        let fontSize = fontSizeSlider.value
        // Save settings logic (e.g., updating global variables or UserDefaults)
        print("Settings Saved: Font Size - \(fontSize)")

        // Provide feedback to user
        let alert = UIAlertController(title: "Settings Saved", message: "Your appearance settings have been saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
