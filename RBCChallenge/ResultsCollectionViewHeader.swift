//
//  ResultsCollectionViewHeader.swift
//  RBCChallenge
//
//  Created by Ke MA on 2017-08-17.
//  Copyright © 2017 Kemin. All rights reserved.
//

import UIKit

class ResultsCollectionViewHeader: UICollectionReusableView {
    
    @IBOutlet weak var sortButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        sortButton.layer.cornerRadius = 2
    }
}
