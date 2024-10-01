//
//  SettingViewController.swift
//  transcribe
//
//  Created by Hompushparaj Mehta on 01/10/24.
//

import UIKit

class SettingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Settings options
    let settingsOptions = [
        "Language Preferences", "Voice Preferences (for TTS)", "History Management",
        "Data Privacy", "Sound Setting", "Appearance Setting",
        "Notifications", "About", "Feedback"
    ]
    let settingImage = [
        "globe.americas","speaker.wave.3","clock","lock.shield","speaker.slash","moon.circle","bell","info.circle","exclamationmark.bubble"
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib.init(nibName: "SettingTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SettingCell")
        
        // Set the delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension SettingViewController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsOptions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell",for: indexPath) as?
        SettingTableViewCell
        
        let name = settingsOptions[indexPath.row]
        
        let systemImageName = settingImage[indexPath.row]
        
        let image = UIImage(systemName: systemImageName) ?? UIImage(systemName: "questionmark.circle")
        let arrow = UIImage(systemName: "chevron.right")
        
        cell?.commonInit(name, image!, arrow!)
        
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedSetting = settingsOptions[indexPath.row]

            // Navigate to the corresponding ViewController based on the selected setting
            var destinationVC: UIViewController?

            switch selectedSetting {
            case "Language Preferences":
                destinationVC = LanguagePreferenceViewController()
            case "Voice Preferences (for TTS)":
                destinationVC = VoicePreferenceViewController()
            case "History Management":
                destinationVC = HistoryManagementViewController()
            case "Data Privacy":
                destinationVC = DataPrivacyViewController()
            case "Sound Setting":
                destinationVC = SoundSettingViewController()
            case "Appearance Setting":
                destinationVC = AppearanceSettingViewController()
            case "Notifications":
                destinationVC = NotificationsViewController()
            case "About":
                destinationVC = AboutViewController()
            case "Feedback":
                destinationVC = FeedbackViewController()
            default:
                break
            }
            
            if let destinationVC = destinationVC {
                navigationController?.pushViewController(destinationVC, animated: true)
            }
        }
    }
