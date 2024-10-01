//
//  DataPrivacyViewController.swift
//  transcribe
//
//  Created by Hompushparaj Mehta on 01/10/24.
//


import UIKit

class DataPrivacyViewController: UIViewController {

    let customTintColor = UIColor(hex: "#FF6026")

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Data Privacy"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Manage your data privacy settings."
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let privacySwitch: UISwitch = {
        let privacySwitch = UISwitch()
        privacySwitch.translatesAutoresizingMaskIntoConstraints = false
        return privacySwitch
    }()
    
    let privacySwitchLabel: UILabel = {
        let label = UILabel()
        label.text = "Enable Data Privacy"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("More Info", for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor(hex: "#FF6026")
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(DataPrivacyViewController.self, action: #selector(moreInfoTapped), for: .touchUpInside)
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
        view.addSubview(descriptionLabel)
        view.addSubview(privacySwitch)
        view.addSubview(privacySwitchLabel)
        view.addSubview(moreInfoButton)

        // Constraints for title label
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        // Constraints for description label
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Constraints for privacy switch label
        NSLayoutConstraint.activate([
            privacySwitchLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            privacySwitchLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        // Constraints for privacy switch
        NSLayoutConstraint.activate([
            privacySwitch.centerYAnchor.constraint(equalTo: privacySwitchLabel.centerYAnchor),
            privacySwitch.leadingAnchor.constraint(equalTo: privacySwitchLabel.trailingAnchor, constant: 10)
        ])
        
        // Constraints for more info button
        NSLayoutConstraint.activate([
            moreInfoButton.topAnchor.constraint(equalTo: privacySwitchLabel.bottomAnchor, constant: 40),
            moreInfoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            moreInfoButton.widthAnchor.constraint(equalToConstant: 120),
            moreInfoButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc func moreInfoTapped() {
        // Implement the action for the button tap
        print("More Info button tapped")
    }
}
