//
//  weeklyTableViewCell.swift
//  RadioNimbus
//
//  Created by Johnson Lin on 2024/11/21.
//

import UIKit

class weeklyTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var dayWeatherImage: UIImageView!
    
    @IBOutlet weak var sunRiseLabel: UILabel!
    
    @IBOutlet weak var sunsetLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
