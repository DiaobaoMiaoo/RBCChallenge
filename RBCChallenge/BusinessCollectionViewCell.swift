//
//  BusinessCollectionViewCell.swift
//  RBCChallenge
//
//  Created by Ke MA on 2017-08-16.
//  Copyright © 2017 Kemin. All rights reserved.
//

import UIKit

protocol BusinessCollectionViewCellDelegate {
    func reloadFavorites()
}

class BusinessCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabelStreet: UILabel!
    @IBOutlet weak var addressLabelCity: UILabel!
    @IBOutlet weak var favButton: FavButton!
    @IBAction func favButtonTapped(_ sender: Any) {
        let favButton = sender as! FavButton
        favButton.favorited = !favButton.favorited
        if favButton.favorited {
            FavoriteManager.sharedInstance.save(business: currentBusiness)
        } else {
            FavoriteManager.sharedInstance.remove(business: currentBusiness)
        }
        
        NotificationCenter.default.post(name: Notification.Name(NotificationConstants.favStatusChanged),
                                        object: nil,
                                        userInfo: ["id": currentBusiness.id ?? "", "status": favButton.favorited])
        
        if delegate != nil {
            delegate!.reloadFavorites()
        }
    }
    
    var currentBusiness: Business!
    var delegate: BusinessCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 3
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImageView.addSubview(blurEffectView)
    }
    
    func setUpWith(business: Business) {
        currentBusiness = business
        nameLabel.text = business.name
        addressLabelStreet.text = business.address.streetName
        addressLabelCity.text = business.address.cityName
        
        if let urlString = business.imageUrl, let url = URL(string: urlString) {
            backgroundImageView.sd_setImage(with: url)
        }
        favButton.favorited = FavoriteManager.sharedInstance.alreadyInFavoriteFor(business: business)
        favButton.associatedId = business.id
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        addressLabelStreet.text = nil
        addressLabelCity.text = nil
        favButton.favorited = false
    }
}
