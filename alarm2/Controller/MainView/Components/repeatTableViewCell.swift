//
//  repeatTableViewCell.swift
//  alarm2
//
//  Created by imac-1681 on 2024/8/13.
//

import UIKit

class repeatTableViewCell: UITableViewCell {
    @IBOutlet var dateLabel: UILabel!
    static let identifier = "repeatTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
