//
//  SettingTableViewCell.swift
//  transcribe
//
//  Created by Hompushparaj Mehta on 01/10/24.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var SettingIcon: UIImageView!
    @IBOutlet weak var SettingArrow: UIImageView!
    @IBOutlet weak var SettingName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        SettingIcon.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func commonInit(_ name: String, _ image: UIImage, _ arrow: UIImage) {
        SettingName.text = name
        SettingIcon.image = image
        SettingArrow.image = arrow
    }
}
