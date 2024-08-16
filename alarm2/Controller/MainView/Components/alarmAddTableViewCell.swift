//
//  alarmAddTableViewCell.swift
//  alarm2
//
//  Created by imac-1681 on 2024/8/16.
//

import UIKit

class alarmAddTableViewCell: UITableViewCell {
    @IBOutlet var alarmSetLabel: UILabel!
    @IBOutlet var pickDateLabel: UILabel!
    static let identifie = "alarmAddTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
