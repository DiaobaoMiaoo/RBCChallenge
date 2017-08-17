//
//  ReviewTableViewCell.swift
//  RBCChallenge
//
//  Created by Ke MA on 2017-08-17.
//  Copyright © 2017 Kemin. All rights reserved.
//

import UIKit
import SDWebImage

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var reviewTimeLabel: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.themeColor.cgColor
        userProfile.layer.cornerRadius = 3
    }
    
    func setUpWith(review: Review) {
        userProfile.sd_setImage(with: URL(string: review.user.imageUrl ?? ""), placeholderImage: UIImage(named: "userPlaceholder"))
        userNameLabel.text = review.user.name ?? ""
        reviewTimeLabel.text = review.reviewTime ?? ""
        reviewTextView.text = review.text ?? ""
    }
}
