//
//  SearchResultViewController.swift
//  RBCChallenge
//
//  Created by Ke MA on 2017-08-16.
//  Copyright © 2017 Kemin. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController {

    @IBOutlet weak var resultsCollectionView: UICollectionView!
    
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
        
        // Do any additional setup after loading the view.
        YelpClient.sharedInstance.getBusinessesWith(keyword: keyword ?? "",
                                                    latitude: LocationClient.sharedInstance.currentLocation?.latitude,
                                                    longitude: LocationClient.sharedInstance.currentLocation?.longitude) { message, businesses in
            self.businesses = businesses ?? []
            self.notSortedBusinesses = businesses ?? []
            self.resultsCollectionView.reloadData()
        }
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
        if segue.identifier == "showDetail", let indexPath = resultsCollectionView.indexPathsForSelectedItems?.first {
            let controller = segue.destination as! DetailViewController
            controller.business = businesses[indexPath.row]
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
