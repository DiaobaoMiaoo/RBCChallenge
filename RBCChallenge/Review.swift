//
//  Review.swift
//  RBCChallenge
//
//  Created by Ke MA on 2017-08-16.
//  Copyright © 2017 Kemin. All rights reserved.
//

import Foundation
import SwiftyJSON

class Review {
    
    struct User {
        var imageUrl: String?
        var name: String?
    }
    
    var url: String?
    var text: String?
    var reviewTime: String?
    var rating: Int?
    var user = User()
}

extension Review {
    
    func getObjectFrom(json: JSON) -> Review {
        url = json["url"].string
        text = json["text"].string
        reviewTime = json["time_created"].string
        rating = json["rating"].int
        user = User(imageUrl: json["user"]["image_url"].string,
                    name: json["user"]["name"].string)
        return self
    }
}
