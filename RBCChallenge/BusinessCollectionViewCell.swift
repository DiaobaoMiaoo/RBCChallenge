//
//  BusinessCollectionViewCell.swift
//  RBCChallenge
//
//  Created by Ke MA on 2017-08-16.
//  Copyright © 2017 Kemin. All rights reserved.
//

import UIKit

class BusinessCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabelStreet: UILabel!
    @IBOutlet weak var addressLabelCity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.themeColor.cgColor
        layer.cornerRadius = 3
    }
    
    func setUpWith(business: Business) {
        nameLabel.text = business.name
        addressLabelStreet.text = business.address.streetName
        addressLabelCity.text = business.address.cityName
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        addressLabelStreet.text = nil
        addressLabelCity.text = nil
    }
}
