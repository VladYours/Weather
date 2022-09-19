//
//  WTableViewCell.swift
//  weather
//
//  Created by Vlad Rakovich on 16.09.2022.
//

import UIKit

class WTableViewCell: UITableViewCell {

    @IBOutlet weak var dayOfWeek: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
