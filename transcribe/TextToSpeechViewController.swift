//
//  TextToSpeechViewController.swift
//  transcribe
//
//  Created by Hompushparaj Mehta on 30/09/24.
//

import UIKit

class TextToSpeechViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var TextInputTextView: UITextView!
    
    let placeholderText = "Enter your text here....."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TextInputTextView.layer.borderColor = UIColor.black.cgColor
        TextInputTextView.layer.borderWidth = 1
        TextInputTextView.layer.cornerRadius = 10
        TextInputTextView.clipsToBounds = true
//        TextInputTextView.becomeFirstResponder()
        
        // Setting initial placeholder
        TextInputTextView.text = placeholderText
        TextInputTextView.textColor = .lightGray
        
        // Setting the delegate to handle text view events
        TextInputTextView.delegate = self
    }
    
    
    // Method to remove placeholder when user start typing
    func textViewDidBeginEditing(_ TextInputTextView: UITextView) {
        if TextInputTextView.text == placeholderText{
            TextInputTextView.text = ""
            TextInputTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ TextInputTextView: UITextView) {
        if TextInputTextView.text.isEmpty {
            TextInputTextView.text = placeholderText
            TextInputTextView.textColor = UIColor.lightGray
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
