//
//  CityTableViewCell.swift
//  weather
//
//  Created by Vlad Rakovich on 17.09.2022.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cityName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
