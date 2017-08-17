//
//  SearchViewController.swift
//  RBCChallenge
//
//  Created by Ke MA on 2017-08-16.
//  Copyright © 2017 Kemin. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var suggestionTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var suggestions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        if YelpClient.sharedInstance.yelpAccessToken?.token == nil {
//            YelpClient.sharedInstance.getAccessToken(completion: { message in
//                YelpClient.sharedInstance.getAutoCompleteSuggestionsFor(keyword: "chinese", completion: { message, suggestions in
//                    self.suggestions = suggestions!
//                    self.suggestionTableView.reloadData()
//                })
//            })
//        }
        // Setup the Search Controller
        
    }
}

// MARK: -- SuggestionTableView Delegate and Datasource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionTableViewCell", for: indexPath) as! SuggestionTableViewCell
        cell.textLabel?.text = suggestions[indexPath.row]
        return cell
    }
}

// MARK: -- UISearchResultsUpdating Delegate
extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}
