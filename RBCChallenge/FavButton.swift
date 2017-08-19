//
//  FavButton.swift
//  RBCChallenge
//
//  Created by Ke MA on 2017-08-18.
//  Copyright © 2017 Kemin. All rights reserved.
//

import UIKit

class FavButton: UIButton {
    
    var favorited: Bool = false {
        didSet {
            if favorited {
                self.setImage(UIImage(named: "favImage"), for: .normal)
            } else {
                self.setImage(UIImage(named: "notFavImage"), for: .normal)
            }
        }
    }
    
    var associatedId: String?
    
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(favStatusChanged(notification:)), name: Notification.Name(NotificationConstants.favStatusChanged), object: nil)
    }
    
    func favStatusChanged(notification: Notification){
        
        guard let id = notification.userInfo?["id"] as? String, let status = notification.userInfo?["status"] as? Bool else {
            return
        }
        
        guard associatedId == id, status != favorited else {
            return
        }
        
        favorited = status
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationConstants.favStatusChanged), object: nil)
    }
}
