//
//  LanguagePreferenceViewController.swift
//  transcribe
//
//  Created by Hompushparaj Mehta on 01/10/24.
//
import UIKit

class LanguagePreferenceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let languages = ["English", "Spanish", "French", "German", "Chinese", "Hindi", "Nepali", "Gujarati"]
    let languageCodes = ["en-US", "es-ES", "fr-FR", "de-DE", "zh-CN", "hi-IN", "ne-NP", "gu-IN"]
    
    var selectedLanguageCode: String = AppSettings.shared.selectedLanguage
    
    let customTintColor = UIColor(hex: "#FF6026")

    let languagePicker = UIPickerView()
    let saveButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Language Preferences"
        view.backgroundColor = .white

        languagePicker.dataSource = self
        languagePicker.delegate = self
        languagePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(languagePicker)

        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = customTintColor
        saveButton.layer.cornerRadius = 10
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveLanguage), for: .touchUpInside)
        view.addSubview(saveButton)

        NSLayoutConstraint.activate([
            languagePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            languagePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            languagePicker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            languagePicker.heightAnchor.constraint(equalToConstant: 150),
            
            saveButton.topAnchor.constraint(equalTo: languagePicker.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Set picker to currently selected language
        if let index = languageCodes.firstIndex(of: AppSettings.shared.selectedLanguage) {
            languagePicker.selectRow(index, inComponent: 0, animated: false)
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLanguageCode = languageCodes[row]
    }

    @objc func saveLanguage() {
        // Update the global language code in AppSettings
        AppSettings.shared.updateLanguage(to: selectedLanguageCode)

        // Show a confirmation message
        let alert = UIAlertController(title: "Success", message: "Language set to \(selectedLanguageCode)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
