//
//  clockTableViewCell.swift
//  alarm2
//
//  Created by imac-1681 on 2024/8/7.
//

import UIKit

class clockTableViewCell: UITableViewCell {

    @IBOutlet var OnOffSwitch: UISwitch!
    @IBOutlet var morning: UILabel!
    @IBOutlet var setTime: UILabel!
    @IBOutlet var repeatDayAndMessage: UILabel!
    static let identifie = "clockTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //OnOffSwitch.addTarget(self, action: #selector(), for: <#T##UIControl.Event#>)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCellAppearance() {
            let isOn = OnOffSwitch.isOn
            let color: UIColor = isOn ? .black : .gray
            
            repeatDayAndMessage.textColor = color
            morning.textColor = color
            setTime.textColor = color
        }
    
}
