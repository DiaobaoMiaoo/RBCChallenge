//
//  ViewController.swift
//  RBCChallenge
//
//  Created by Ke MA on 2017-08-15.
//  Copyright © 2017 Kemin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        YelpClient.sharedInstance.getAccessToken { message in
            YelpClient.sharedInstance.getAutoCompleteSuggestionsFor(keyword: "del",latitude: "37.786882", longitude: "-122.399972", completion: { message, suggestions in
                print(suggestions)
                })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

