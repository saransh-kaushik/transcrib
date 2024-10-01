//
//  FeedbackViewController.swift
//  transcribe
//
//  Created by Hompushparaj Mehta on 01/10/24.
//

import UIKit

class FeedbackViewController: UIViewController {

    let customTintColor = UIColor(hex: "#FF6026")
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Feedback"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let feedbackTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .darkGray
        textView.text = "Enter your feedback here..."
        textView.textColor = .lightGray
        return textView
    }()

    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor(hex: "#FF6026")
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        // Set the delegate for the feedback text view
        feedbackTextView.delegate = self
        
        // Set the action for the submit button
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    }

    private func setupUI() {
        // Add views to the main view
        view.addSubview(titleLabel)
        view.addSubview(feedbackTextView)
        view.addSubview(submitButton)

        // Constraints for title label
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        // Constraints for feedback text view
        NSLayoutConstraint.activate([
            feedbackTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            feedbackTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            feedbackTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            feedbackTextView.heightAnchor.constraint(equalToConstant: 150)
        ])

        // Constraints for submit button
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: feedbackTextView.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 150),
            submitButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc func submitTapped() {
        // Handle feedback submission
        if let feedback = feedbackTextView.text, !feedback.isEmpty, feedback != "Enter your feedback here..." {
            print("Feedback submitted: \(feedback)")
            // Perform any additional actions for feedback submission, e.g., API call or saving to a database
            feedbackTextView.text = "Thank you for your feedback!"
            feedbackTextView.textColor = .lightGray
        } else {
            // Show an alert for empty feedback
            showAlert("Please enter valid feedback.")
        }
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension FeedbackViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.darkGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your feedback here..."
            textView.textColor = UIColor.lightGray
        }
    }
}
