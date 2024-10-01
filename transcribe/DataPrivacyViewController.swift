//
//  DataPrivacyViewController.swift
//  transcribe
//
//  Created by Hompushparaj Mehta on 01/10/24.
//


import UIKit

class DataPrivacyViewController: UIViewController {

    private let dataCollectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Data Collection"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let locationDataSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()

    private let locationDataLabel: UILabel = {
        let label = UILabel()
        label.text = "Location Data"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let usageAnalyticsSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()

    private let usageAnalyticsLabel: UILabel = {
        let label = UILabel()
        label.text = "Usage Analytics"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let personalizationDataSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()

    private let personalizationDataLabel: UILabel = {
        let label = UILabel()
        label.text = "Personalization Data"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Data Privacy" // Set the screen title
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(dataCollectionLabel)
        view.addSubview(locationDataLabel)
        view.addSubview(locationDataSwitch)
        view.addSubview(usageAnalyticsLabel)
        view.addSubview(usageAnalyticsSwitch)
        view.addSubview(personalizationDataLabel)
        view.addSubview(personalizationDataSwitch)

        NSLayoutConstraint.activate([
            // Data Collection Label
            dataCollectionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dataCollectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            // Location Data Switch and Label
            locationDataLabel.topAnchor.constraint(equalTo: dataCollectionLabel.bottomAnchor, constant: 20),
            locationDataLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            locationDataSwitch.centerYAnchor.constraint(equalTo: locationDataLabel.centerYAnchor),
            locationDataSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Usage Analytics Switch and Label
            usageAnalyticsLabel.topAnchor.constraint(equalTo: locationDataLabel.bottomAnchor, constant: 20),
            usageAnalyticsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usageAnalyticsSwitch.centerYAnchor.constraint(equalTo: usageAnalyticsLabel.centerYAnchor),
            usageAnalyticsSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Personalization Data Switch and Label
            personalizationDataLabel.topAnchor.constraint(equalTo: usageAnalyticsLabel.bottomAnchor, constant: 20),
            personalizationDataLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            personalizationDataSwitch.centerYAnchor.constraint(equalTo: personalizationDataLabel.centerYAnchor),
            personalizationDataSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
}
