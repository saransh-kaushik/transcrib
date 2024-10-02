//
//  ViewController.swift
//  transcribe
//
//  Created by Hompushparaj Mehta on 28/09/24.
//

import UIKit

// Move AudioAction struct outside of ViewController so it can be used globally
struct AudioAction: Codable {
    let titleLabel: String
    let subTitleLabel: String
    let timestampLabel: String
    let audioPath: String
    
    var playIcon: String {
        switch titleLabel {
        case "Text to Speech":
            return "play.circle"
        case "Speech to Text":
            return "microphone"
        default:
            return "questionmark.circle"
        }
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var recentConversationTableView: UITableView!
    
    var actions: [AudioAction] = []
    var fileMonitorSource: DispatchSourceFileSystemObject?
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    // Function to display recent conversation dynamically
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationTableViewCell
//         Get the current action based on the index path
        let action = actions[indexPath.row]
        
        cell.conversationImage.image = UIImage(systemName: action.playIcon)
        cell.conversationTitle.text = action.titleLabel
        cell.conversationSubtitle.text = "\(action.subTitleLabel) - \(timeDifference(from: action.timestampLabel) ?? "0 min ago")"
        
        if let time = extractTime(from: action.timestampLabel){
            cell.conversationTime.text = time
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedAction = actions[indexPath.row]
        
        // Instantiate AudioViewController from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let audioPlayerVC = storyboard.instantiateViewController(withIdentifier: "AudioViewController") as? AudioViewController {
            
            // Pass the selected action to the audio player view controller
            audioPlayerVC.audioAction = selectedAction
            
            // Push the audio player view controller onto the navigation stack
            navigationController?.pushViewController(audioPlayerVC, animated: true)
        } else {
            print("Failed to instantiate AudioViewController")
        }
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
    
    func loadAudioActions() -> [AudioAction] {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsDirectory.appendingPathComponent("audioActions.json")
        
        do {
            let data = try Data(contentsOf: filePath)
            let audioActions = try JSONDecoder().decode([AudioAction].self, from: data)
            return audioActions
        } catch {
            print("Error loading audio actions: \(error)")
            return []
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "ConversationTableViewCell", bundle: nil)
        recentConversationTableView.register(nib, forCellReuseIdentifier: "ConversationCell")
        
        recentConversationTableView.dataSource = self
        recentConversationTableView.delegate = self
        
        actions = loadAudioActions()

    }
    
    // Reload audio actions and refresh the table when the view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reload the audio actions and refresh the table view
        actions = loadAudioActions()
        recentConversationTableView.reloadData()
    }
}

