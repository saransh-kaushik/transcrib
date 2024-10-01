//
//  NotificationsViewController.swift
//  transcribe
//
//  Created by Hompushparaj Mehta on 01/10/24.
//

import UIKit

class NotificationsViewController: UIViewController {

    let customTintColor = UIColor(hex: "#FF6026")

    let enableNotificationsSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true // Default state
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    let enableNotificationsLabel: UILabel = {
        let label = UILabel()
        label.text = "Enable Notifications"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let messageNotificationsLabel: UILabel = {
        let label = UILabel()
        label.text = "Message Notifications"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let messageNotificationsSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true // Default state
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    let commentNotificationsLabel: UILabel = {
        let label = UILabel()
        label.text = "Comment Notifications"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let commentNotificationsSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false // Default state
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    let likeNotificationsLabel: UILabel = {
        let label = UILabel()
        label.text = "Like Notifications"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let likeNotificationsSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false // Default state
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Settings", for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor(hex: "#FF6026")
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(NotificationsViewController.self, action: #selector(saveSettingsTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Notification"
        setupUI()
    }

    private func setupUI() {
        // Add views to the main view
        view.addSubview(enableNotificationsLabel)
        view.addSubview(enableNotificationsSwitch)
        view.addSubview(messageNotificationsLabel)
        view.addSubview(messageNotificationsSwitch)
        view.addSubview(commentNotificationsLabel)
        view.addSubview(commentNotificationsSwitch)
        view.addSubview(likeNotificationsLabel)
        view.addSubview(likeNotificationsSwitch)
        view.addSubview(saveButton)

        // Constraints for enable notifications label
        NSLayoutConstraint.activate([
            enableNotificationsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            enableNotificationsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        
        // Constraints for enable notifications switch
        NSLayoutConstraint.activate([
            enableNotificationsSwitch.centerYAnchor.constraint(equalTo: enableNotificationsLabel.centerYAnchor),
            enableNotificationsSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Constraints for message notifications label
        NSLayoutConstraint.activate([
            messageNotificationsLabel.topAnchor.constraint(equalTo: enableNotificationsLabel.bottomAnchor, constant: 20),
            messageNotificationsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        // Constraints for message notifications switch
        NSLayoutConstraint.activate([
            messageNotificationsSwitch.centerYAnchor.constraint(equalTo: messageNotificationsLabel.centerYAnchor),
            messageNotificationsSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Constraints for comment notifications label
        NSLayoutConstraint.activate([
            commentNotificationsLabel.topAnchor.constraint(equalTo: messageNotificationsLabel.bottomAnchor, constant: 20),
            commentNotificationsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        // Constraints for comment notifications switch
        NSLayoutConstraint.activate([
            commentNotificationsSwitch.centerYAnchor.constraint(equalTo: commentNotificationsLabel.centerYAnchor),
            commentNotificationsSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Constraints for like notifications label
        NSLayoutConstraint.activate([
            likeNotificationsLabel.topAnchor.constraint(equalTo: commentNotificationsLabel.bottomAnchor, constant: 20),
            likeNotificationsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        // Constraints for like notifications switch
        NSLayoutConstraint.activate([
            likeNotificationsSwitch.centerYAnchor.constraint(equalTo: likeNotificationsLabel.centerYAnchor),
            likeNotificationsSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Constraints for save button
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: likeNotificationsLabel.bottomAnchor, constant: 40),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc func saveSettingsTapped() {
        // Save settings logic (e.g., updating global variables or UserDefaults)
        let messageNotificationsEnabled = messageNotificationsSwitch.isOn
        let commentNotificationsEnabled = commentNotificationsSwitch.isOn
        let likeNotificationsEnabled = likeNotificationsSwitch.isOn
        
        // Save these preferences in your global variable or UserDefaults
        print("Settings Saved: Message - \(messageNotificationsEnabled), Comment - \(commentNotificationsEnabled), Like - \(likeNotificationsEnabled)")

        // Provide feedback to user
        let alert = UIAlertController(title: "Settings Saved", message: "Your notification settings have been saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
