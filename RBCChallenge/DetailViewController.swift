//
//  DetailViewController.swift
//  RBCChallenge
//
//  Created by Ke MA on 2017-08-16.
//  Copyright © 2017 Kemin. All rights reserved.
//

import UIKit

class DetailViewController: BaseViewController {

    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var business: Business?
    var reviews = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let business = business {
            
            // Set up the detail view for business
            businessNameLabel.text = business.name ?? ""
            businessImageView.sd_setImage(with: URL(string: business.imageUrl ?? ""), placeholderImage: UIImage(named: ""))
            streetLabel.text = business.address.streetName ?? ""
            cityLabel.text = business.address.cityName ?? ""
            
            // Fetch the most recent reviews and load them
            YelpClient.sharedInstance.getReviewsFor(business: business) { message, reviews in
                self.reviews = reviews ?? []
                self.detailTableView.reloadData()
            }
        } else {
        
        }
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
        cell.setUpWith(review: reviews[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Reviews"
    }
}
