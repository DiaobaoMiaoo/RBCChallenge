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
    @IBOutlet weak var favButton: FavButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var business: Business?
    var reviews = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = nil
        
        guard let business = business else {
            let placeHolderView = UIView(frame: view.frame)
            placeHolderView.backgroundColor = UIColor.white
            view.addSubview(placeHolderView)
            return
        }
        
        detailTableView.estimatedRowHeight = 189.0
        detailTableView.rowHeight = UITableViewAutomaticDimension
        detailTableView.separatorStyle = .singleLine
        detailTableView.separatorColor = UIColor.themeColor
        detailTableView.tableFooterView = UIView()
        businessImageView.layer.cornerRadius = 3
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImageView.addSubview(blurEffectView)
            
        // Set up the detail view for business
        businessNameLabel.text = business.name ?? ""
        businessImageView.sd_setImage(with: URL(string: business.imageUrl ?? ""), placeholderImage: UIImage(named: "businessPlaceHolder"))
        backgroundImageView.sd_setImage(with: URL(string: business.imageUrl ?? ""), placeholderImage: UIImage(named: "businessPlaceHolder"))
        streetLabel.text = business.address.streetName ?? ""
        cityLabel.text = business.address.cityName ?? ""
        favButton.favorited = FavoriteManager.sharedInstance.alreadyInFavoriteFor(business: business)
        favButton.associatedId = business.id
        favButton.addTarget(self, action: #selector(favButtonTapped(_:)), for: .touchUpInside)
        
        // Fetch the most recent reviews and load them
        
        YelpClient.sharedInstance.getReviewsFor(business: business) { message, reviews in    
            self.reviews = reviews ?? []
            self.detailTableView.reloadData()
        }
    }
    
    func favButtonTapped(_ sender: FavButton) {
        guard let business = business else {
            return
        }
        sender.favorited = !sender.favorited
        if favButton.favorited {
            FavoriteManager.sharedInstance.save(business: business)
        } else {
            FavoriteManager.sharedInstance.remove(business: business)
        }
        
        NotificationCenter.default.post(name: Notification.Name(NotificationConstants.favStatusChanged),
                                        object: nil,
                                        userInfo: ["id": business.id ?? "", "status": favButton.favorited])
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: 320, height: 30))
        label.text = "Reviews"
        label.font = UIFont.boldSystemFont(ofSize: 23.0)
        
        let headerView = UIView()
        headerView.addSubview(label)
        headerView.backgroundColor = UIColor.themeColor
        return headerView
    }
}
