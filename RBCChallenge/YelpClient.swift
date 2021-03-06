//
//  YelpClient.swift
//  RBCChallenge
//
//  Created by Ke MA on 2017-08-15.
//  Copyright © 2017 Kemin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Strongbox

struct RequestStatus {
    static let success = "success"
    static let fail = "fail"
}

class YelpClient {
    
    fileprivate let yelpClientID     = "3q3vvC5XwA9GW_FWyb_o_Q"
    fileprivate let yelpClientSecret = "36Tuzqoc7as79W8b5lWwei2PI3VXvvdlxRmSSZ0X727KifPBviNk6hXZvxzsQ7Na"
    fileprivate struct YelpURLs {
        static let token        = "https://api.yelp.com/oauth2/token"
        static let search       = "https://api.yelp.com/v3/businesses/search"
        static let reviews      = "https://api.yelp.com/v3/businesses/" // + {id}/reviews
        static let autoComplete = "https://api.yelp.com/v3/autocomplete"
    }
    
    struct YelpAccessToken {
        var token: String?
        var type: String?
        var expiry: Double?
        var creationTime: Double
        
        init(token: String?, type: String?, expiry: Double?, creationTime: Double) {
            self.token = token
            self.type = type
            self.expiry = expiry
            self.creationTime = creationTime
        }
    }
    
    var yelpAccessToken: YelpAccessToken?
    
    static let sharedInstance = YelpClient()
    
    /*
     Function to get the Yelp access token.
     */
    func getAccessToken(completion: @escaping (String) -> ()) {
        
        let accessTokenURL = URL(string: YelpURLs.token)!
        let parameters = ["client_id": yelpClientID, "client_secret": yelpClientSecret]
        
        if let accessToken = getValidTokenFromKeychain() {
            yelpAccessToken = accessToken
            completion(RequestStatus.success)
        } else {
            Alamofire.request(accessTokenURL,
                              method: .post,
                              parameters: parameters,
                              encoding: URLEncoding.default,
                              headers: nil).responseJSON { response in
                                
                                switch response.result {
                                case .success(let value):
                                    let json = JSON(value)
                                    self.yelpAccessToken = YelpAccessToken(token: json["access_token"].string,
                                                                           type: json["token_type"].string,
                                                                           expiry: json["expires_in"].double,
                                                                           creationTime: NSDate().timeIntervalSince1970)
                                    self.saveToKeychain(tokenStruct: self.yelpAccessToken!)
                                    completion(RequestStatus.success)
                                case .failure(let error):
                                    completion(error.localizedDescription)
                                }
            }
        }
    }
}

// MARK: -- API Functions
extension YelpClient {

    /*
     Get the Yelp businesses based on user's keyword and location.
     Set "limit" to adjust the number of fetched business with a default of 10.
     */
    func getBusinessesWith(keyword: String, limit: Int = 10,
                           latitude: String?, longitude: String?,
                           completion: @escaping (String, [Business]?) -> ()) {
        
        guard let token = yelpAccessToken?.token, let type = yelpAccessToken?.type else {
            completion("no token", nil)
            return
        }
        
        let searchURL = URL(string: YelpURLs.search)!
        let headers = ["Authorization": type + " " + token]
        let parameters: [String: Any] = ["term": keyword,
                                         "latitude": latitude ?? "43.646046",
                                         "longitude": longitude ?? "-79.385487",
                                         "limit": limit,
                                         "categories": "restaurants"]
        
        Alamofire.request(searchURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let businessJsonArray = JSON(value)["businesses"].array ?? []
                var businessArray = [Business]()
                for businessJson in businessJsonArray {
                    let business = Business().getObjectFrom(json: businessJson)
                    businessArray.append(business)
                }
                completion(RequestStatus.success, businessArray)
            case .failure(let error):
                completion(error.localizedDescription, nil)
            }
        }
    }
    
    /*
     Get most recent 3 reviews for the business.
     */
    func getReviewsFor(business: Business, completion: @escaping (String, [Review]?) -> ()) {
        
        guard let token = yelpAccessToken?.token, let type = yelpAccessToken?.type else {
            completion("no token", nil)
            return
        }
        
        guard let id = business.id else {
            completion("no business id", nil)
            return
        }
        
        // "Id" might contain special characters. So we need to process the url a little bit more.
        let urlString = YelpURLs.reviews + "\(id)/reviews"
        guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let reviewURL = URL(string: encoded) else {
            return
        }
        
        let headers = ["Authorization": type + " " + token]
        
        Alamofire.request(reviewURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let reviewJsonArray = JSON(value)["reviews"].array ?? []
                var reviewArray = [Review]()
                for reviewJson in reviewJsonArray {
                    let review = Review().getObjectFrom(json: reviewJson)
                    reviewArray.append(review)
                }
                completion(RequestStatus.success, reviewArray)
            case .failure(let error):
                print(error.localizedDescription)
                completion(error.localizedDescription, nil)
            }
        }
    }
    
    /*
     Get autocomplete suggestions based on user's input and location.
     */
    func getAutoCompleteSuggestionsFor(keyword: String, latitude: String = "43.646046", longitude: String = "-79.385487", completion: @escaping (String, [String]?) -> ()) {
        
        guard let token = yelpAccessToken?.token, let type = yelpAccessToken?.type else {
            completion("no token", nil)
            return
        }
        
        let autoCompleteURL = URL(string: YelpURLs.autoComplete)!
        let headers = ["Authorization": type + " " + token]
        let parameters: [String: Any] = ["text": keyword, "latitude": latitude, "longitude": longitude]
        
        Alamofire.request(autoCompleteURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let suggestionArray = self.getAutoCompletionSuggestions(json: JSON(value))
                completion(RequestStatus.success, suggestionArray)
            case .failure(let error):
                completion(error.localizedDescription, nil)
            }
        }
    }
}

// MARK: -- Keychain Management
extension YelpClient {
    
    /*
     Save the YelpAccessToken to keychain
     */
    fileprivate func saveToKeychain(tokenStruct: YelpAccessToken) {
        guard let token = tokenStruct.token,
            let expiry = tokenStruct.expiry,
            let type = tokenStruct.type  else {
                return
        }
        let strongBox = Strongbox()
        let _ = strongBox.archive(token, key: "token")
        let _ = strongBox.archive(expiry, key: "expiry")
        let _ = strongBox.archive(type, key: "type")
        let _ = strongBox.archive(tokenStruct.creationTime, key: "creationTime")
    }
    
    /*
     Get the YelpAccessToken from keychain if it is still valid.
     Return nil if no valid token found from keychain
     */
    fileprivate func getValidTokenFromKeychain() -> YelpAccessToken? {
        let strongBox = Strongbox()
        
        guard let token = strongBox.unarchive(objectForKey: "token") as? String,
            let expiry = strongBox.unarchive(objectForKey: "expiry") as? Double,
            let type = strongBox.unarchive(objectForKey: "type") as? String,
            let creationTime = strongBox.unarchive(objectForKey: "creationTime") as? Double else {
                return nil
        }
        
        guard validateToken(creationTime: creationTime, expiry: expiry) else {
            return nil
        }
        
        return YelpAccessToken(token: token, type: type, expiry: expiry, creationTime: creationTime)
    }
    
    /*
    Check the token is valid or expired.
     */
    fileprivate func validateToken(creationTime: Double, expiry: Double) -> Bool {
        let currentTime = NSDate().timeIntervalSince1970
        if creationTime + expiry > currentTime {
            return true
        } else {
            return false
        }
    }
}

// MARK: -- Helper Functions
extension YelpClient {
    
    /*
     Get the suggestions from all three categories "terms", "businesses" and "categories".
     The suggestion we need for each category has the keyword "text", "name" and "title" accordingly.
     */
    fileprivate func getAutoCompletionSuggestions(json: JSON) -> [String] {
        let key_SubKey_Dict = ["terms": "text",
                               "businesses": "name",
                               "categories": "title"]
        var suggestions = [String]()
        
        for (key, subKey) in key_SubKey_Dict {
            // get the specific cateory with the key
            let resultsForKey = json[key].array ?? []
            for result in resultsForKey {
                // for each time in the spefic category, get the suggestion using subkey
                if let suggestion = result[subKey].string {
                    suggestions.append(suggestion)
                }
            }
        }
        return suggestions
    }
}
