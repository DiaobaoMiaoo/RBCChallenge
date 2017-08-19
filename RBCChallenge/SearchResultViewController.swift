//
//  SearchResultViewController.swift
//  RBCChallenge
//
//  Created by Ke MA on 2017-08-16.
//  Copyright © 2017 Kemin. All rights reserved.
//

import UIKit

class SearchResultViewController: BaseViewController {

    @IBOutlet weak var resultsCollectionView: UICollectionView!
    @IBOutlet weak var noContentView: UIView!
    @IBOutlet weak var noContentLabel: UILabel!
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var keyword: String?
    // Array that contains the sorted elements
    var businesses = [Business]()
    // Array that contains the elements with their original order. This array shall not be changed once get the value from YelpClient
    var notSortedBusinesses = [Business]()
    
    enum SortCriteria: String {
        case ascending = "Ascending"
        case descending = "Descending"
        case relevance = "Relevance"
    }
    var currentSortCriteria: SortCriteria = .relevance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noContentView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFavorites), name: Notification.Name(NotificationConstants.favStatusChanged), object: nil)
        
        // Do any additional setup after loading the view.
        if let keyword = keyword {
            navigationItem.title = "Results"
            resultsCollectionView.activityIndicatorView.startAnimating()
            YelpClient.sharedInstance.getBusinessesWith(keyword: keyword,
                                                        latitude: LocationClient.sharedInstance.currentLocation?.latitude,
                                                        longitude: LocationClient.sharedInstance.currentLocation?.longitude) { message, businesses in
                                                            self.resultsCollectionView.activityIndicatorView.stopAnimating()
                                                            self.businesses = businesses ?? []
                                                            self.notSortedBusinesses = businesses ?? []
                                                            
                                                            if businesses?.count == 0 {
                                                                self.noContentView.isHidden = false
                                                                self.noContentLabel.text = "No results found for your keyword. Please try something different."
                                                            } else {
                                                                self.noContentView.isHidden = true
                                                            }
                                                            self.resultsCollectionView.reloadData()
            }
        } else {
            navigationItem.title = "Favorites"
            loadFavorites()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationConstants.favStatusChanged), object: nil)
    }
}

// MARK: -- CollectionView DataSource, Delegate and FlowLayout
extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = resultsCollectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCollectionViewCell", for: indexPath) as! BusinessCollectionViewCell
        cell.setUpWith(business: businesses[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * 3
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / 2
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ResultsCollectionViewHeader", for: indexPath) as! ResultsCollectionViewHeader
            headerView.backgroundColor = UIColor.themeColor
            headerView.sortButton.addTarget(self, action: #selector(sortButtonTapped(_:)), for: .touchUpInside)
            headerView.sortButton.setTitle("Sort By: \(currentSortCriteria.rawValue)", for: .normal)
            return headerView
        default:
            // This is not suppose to happen
            return UICollectionReusableView()
        }
    }
}

// MARK: -- Segues
extension SearchResultViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = resultsCollectionView.indexPathsForSelectedItems?.first,
           let destNav = segue.destination as? UINavigationController,
           let detailController = destNav.topViewController as? DetailViewController {
                detailController.business = businesses[indexPath.row]
        }
    }
}

// MARK: -- Sort
extension SearchResultViewController {

    @objc fileprivate func sortButtonTapped(_ sender: UIButton) {
        currentSortCriteria = getNextSortCriteria()
        self.sortBusinessBy(currentSortCriteria)
    }
    
    fileprivate func getNextSortCriteria() -> SortCriteria {
        switch currentSortCriteria {
        case .relevance:
            return .ascending
        case .ascending:
            return .descending
        case .descending:
            return .relevance
        }
    }
    
    fileprivate func sortBusinessBy(_ criteria: SortCriteria) {
        
        switch criteria {
        case .ascending:
            businesses.sort { $0.name ?? "" < $1.name ?? "" }
        case .descending:
            businesses.sort { $0.name ?? "" > $1.name ?? "" }
        case .relevance:
            businesses = notSortedBusinesses
        }
        resultsCollectionView.reloadData()
    }
}

// MARK: -- Favorites Handling
extension SearchResultViewController: BusinessCollectionViewCellDelegate {
    
    func loadFavorites() {
        businesses = FavoriteManager.sharedInstance.fetchAllFavorites()
        notSortedBusinesses = businesses
        
        if businesses.count == 0 {
            noContentView.isHidden = false
            noContentLabel.text = "No favorites yet. Browse the restaurants and add the ones you like!"
        } else {
            noContentView.isHidden = true
        }
        resultsCollectionView.reloadData()
    }
    
    func reloadFavorites() {
        if keyword == nil {
            loadFavorites()
        }
    }
}
