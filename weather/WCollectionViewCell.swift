//
//  WCollectionViewCell.swift
//  weather
//
//  Created by Vlad Rakovich on 16.09.2022.
//

import UIKit

class WCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var hour: UILabel!
    @IBOutlet weak var min: UILabel!
    @IBOutlet weak var wImg: UIImageView!
    @IBOutlet weak var temp: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
