//
//  ViewController.swift
//  transcribe
//
//  Created by Hompushparaj Mehta on 28/09/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct AudioAction {
        let titleLabel: String
        let subTitleLabel: String
        let timestampLabel: String
        let playIcon: String
    }

    let actions: [AudioAction] = [
        AudioAction(titleLabel: "Speech to Text", subTitleLabel: "Voice Memo", timestampLabel: "2024-09-30 3:45 PM", playIcon: "microphone"),
        AudioAction(titleLabel: "Text to Speech", subTitleLabel: "Book Summary", timestampLabel: "2024-09-30 2:00 PM", playIcon: "play.circle"),
        AudioAction(titleLabel: "Speech to Text", subTitleLabel: "Meeting Notes", timestampLabel: "2024-09-30 12:30 PM", playIcon: "microphone"),
        AudioAction(titleLabel: "Text to Speech", subTitleLabel: "Podcast", timestampLabel: "2024-09-30 11:15 AM", playIcon: "play.circle"),
        AudioAction(titleLabel: "Text to Speech", subTitleLabel: "News article", timestampLabel: "2024-09-30 9:41 AM", playIcon: "play.circle"),
        AudioAction(titleLabel: "Speech to Text", subTitleLabel: "Lecture Summary", timestampLabel: "2024-09-30 10:00 AM", playIcon: "microphone"),
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    // Function to display recent conversation dynamically
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        // Get the current action based on the index path
        let action = actions[indexPath.row]
        
        cell.playIcon.image = UIImage(systemName: action.playIcon)
        cell.titleLabel.text = action.titleLabel
        cell.subtitleLabel.text = "\(action.subTitleLabel) - \(timeDifference(from: action.timestampLabel) ?? "0 min ago")"
        
        if let time = extractTime(from: action.timestampLabel){
            cell.timestampLabel.text = time
        }
        return cell
    }
    
    
    // Function to calculate time difference between current time and provided full timestamp
    func timeDifference(from timestamp: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd h:mm a"  // Full date-time format, e.g., "2024-09-27 9:41 AM"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Convert the timestamp string to a Date object
        guard let timestampDate = formatter.date(from: timestamp) else { return nil }
        
        let currentTime = Date()
        
        // Calculate the time interval
        let timeInterval = currentTime.timeIntervalSince(timestampDate)
        
        let minutes = Int(timeInterval / 60)
        let hours = minutes / 60
        
        if minutes < 60 {
            return "\(minutes) min ago"
        } else if hours < 24 {
            return "\(hours) hour(s) ago"
        } else {
            return "\(hours / 24) day(s) ago"
        }
    }

    // Function to extract time from timestamp label
    func extractTime(from timestamp: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd h:mm a"  // Full date-time format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Convert the timestamp string to a Date object
        guard let date = formatter.date(from: timestamp) else { return nil }
        
        // Create a new formatter to extract only the time
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"  // Time format, e.g., "9:41 AM"
        
        return timeFormatter.string(from: date)
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }


}

