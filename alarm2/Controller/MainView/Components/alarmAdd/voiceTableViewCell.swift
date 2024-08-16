//
//  voiceTableViewCell.swift
//  alarm2
//
//  Created by imac-1681 on 2024/8/13.
//

import UIKit

class voiceTableViewCell: UITableViewCell {
    @IBOutlet var voiceLabel: UILabel!
    static let identifie = "voiceTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
