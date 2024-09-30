//
//  SpeechToTextViewController.swift
//  transcribe
//
//  Created by Hompushparaj Mehta on 30/09/24.
//

import UIKit

class SpeechToTextViewController: UIViewController {

    @IBOutlet weak var liveTranscriptionAreaTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        liveTranscriptionAreaTextView.layer.borderColor = UIColor.black.cgColor
        liveTranscriptionAreaTextView.layer.borderWidth = 1
        liveTranscriptionAreaTextView.layer.cornerRadius = 10
        liveTranscriptionAreaTextView.clipsToBounds = true
        liveTranscriptionAreaTextView.isEditable = false
    }
}
