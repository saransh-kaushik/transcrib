//
//  ViewController.swift
//  transcribe
//
//  Created by Hompushparaj Mehta on 28/09/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
            cell.playIcon.image = UIImage(systemName: "play.circle.fill")
            cell.titleLabel.text = "Text to Speech"
            cell.subtitleLabel.text = "News article - \(indexPath.row * 10) min ago"
            cell.timestampLabel.text = "9:41 AM"
            return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }


}

