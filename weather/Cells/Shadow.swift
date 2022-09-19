//
//  Shadow.swift
//  weather
//
//  Created by Vlad Rakovich on 19.09.2022.
//

import UIKit

class Shadow: UIView {

    override var bounds: CGRect {
            didSet {
                setupShadow()
            }
        }

        private func setupShadow() {
            self.layer.shadowOffset = CGSize(width: 0, height: 3)
            self.layer.shadowOpacity = 0.3
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = UIScreen.main.scale
            self.layer.shadowColor = UIColor.blue.cgColor
        }
}
