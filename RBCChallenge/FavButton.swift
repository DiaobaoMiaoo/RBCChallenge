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
}
