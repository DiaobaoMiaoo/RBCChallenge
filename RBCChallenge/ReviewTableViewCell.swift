//
//  ReviewTableViewCell.swift
//  RBCChallenge
//
//  Created by Ke MA on 2017-08-17.
//  Copyright © 2017 Kemin. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var reviewTimeLabel: UILabel!
    
    @IBOutlet weak var reviewTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
