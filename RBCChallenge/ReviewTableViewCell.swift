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
    @IBOutlet weak var reviewTextView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userProfile.layer.cornerRadius = 5
        for tag in 1...5 {
            (viewWithTag(tag) as! UIImageView).layer.cornerRadius = 5
        }
    }
    
    func setUpWith(review: Review) {
        userProfile.sd_setImage(with: URL(string: review.user.imageUrl ?? ""), placeholderImage: UIImage(named: "userPlaceholder"))
        userNameLabel.text = review.user.name ?? ""
        reviewTextView.text = review.text ?? ""
        reviewTimeLabel.text = review.reviewTime?.components(separatedBy: " ")[0] ?? ""
        
        if let starsDouble = review.rating, starsDouble >= 1 {
            let stars = Int(floor(starsDouble))
            for tag in 1...stars {
                (viewWithTag(tag) as! UIImageView).image = #imageLiteral(resourceName: "starFull")
            }
            for tag in stars...5 {
                (viewWithTag(tag) as! UIImageView).image = #imageLiteral(resourceName: "starEmpty")
            }
        }
    }
    
    override func prepareForReuse() {
        userProfile.image = nil
        userNameLabel.text = nil
        reviewTextView.text = nil
        reviewTimeLabel.text = nil
        for tag in 1...5 {
            (viewWithTag(tag) as! UIImageView).image = #imageLiteral(resourceName: "starEmpty")
        }
    }
}
