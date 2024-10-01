//
//  ConversationTableViewCell.swift
//  transcribe
//
//  Created by Hompushparaj Mehta on 01/10/24.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    @IBOutlet weak var conversationImage: UIImageView!
    @IBOutlet weak var conversationTitle: UILabel!
    
    @IBOutlet weak var conversationSubtitle: UILabel!
    
    @IBOutlet weak var conversationTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.conversationImage.layer.cornerRadius = conversationImage.frame.size.width / 2
        conversationImage.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func commonInit(_ name: String,_ subtitle: String,_ timestamp:String, _ image: UIImage) {
        conversationTitle.text = name
        conversationSubtitle.text = subtitle
        conversationTime.text = timestamp
        conversationImage.image = image
    }
    
}
