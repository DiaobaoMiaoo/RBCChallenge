//
//  Business.swift
//  RBCChallenge
//
//  Created by Ke MA on 2017-08-16.
//  Copyright © 2017 Kemin. All rights reserved.
//

import Foundation
import SwiftyJSON

class Business: NSObject {

    struct DisplayAddress {
        var streetName: String?
        var cityName: String?
    }
    
    var id: String?
    var name: String?
    var imageUrl: String?
    var address = DisplayAddress()
}

extension Business {
    
    func getObjectFrom(json: JSON) -> Business {
        id = json["id"].string
        name = json["name"].string
        imageUrl = json["image_url"].string
        address = DisplayAddress(streetName: json["location"]["display_address"][0].string,
                                                   cityName: json["location"]["display_address"][1].string)
        return self
    }
    
    func getObjectFrom(entity: BusinessEntity) -> Business {
        id = entity.id
        name = entity.name
        imageUrl = entity.imageURL
        address = DisplayAddress(streetName: entity.street,
                                 cityName: entity.city)
        return self
    }
}
