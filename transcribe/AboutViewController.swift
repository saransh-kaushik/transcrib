//
//  AboutViewController.swift
//  transcribe
//
//  Created by Hompushparaj Mehta on 01/10/24.
//

import UIKit

class AboutViewController: UIViewController {

    let customTintColor = UIColor(hex: "#FF6026")
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "About This App"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Transcribe is a powerful application that enables users to convert speech to text in real-time, making it an essential tool for note-taking, accessibility, and more."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let versionLabel: UILabel = {
        let label = UILabel()
        label.text = "Version: 1.0.0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "Created by: Hompushparaj Mehta"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dismiss", for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor(hex: "#FF6026")
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(AboutViewController.self, action: #selector(dismissTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "About"
        setupUI()
    }

    private func setupUI() {
        // Add views to the main view
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(versionLabel)
        view.addSubview(authorLabel)
        view.addSubview(dismissButton)

        // Constraints for title label
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Constraints for description label
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        // Constraints for version label
        NSLayoutConstraint.activate([
            versionLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        // Constraints for author label
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 10),
            authorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        // Constraints for dismiss button
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 40),
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.widthAnchor.constraint(equalToConstant: 150),
            dismissButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc func dismissTapped() {
        // Dismiss the About view controller
        self.dismiss(animated: true, completion: nil)
    }
}
