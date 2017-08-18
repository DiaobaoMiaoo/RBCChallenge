//
//  SearchViewController.swift
//  RBCChallenge
//
//  Created by Ke MA on 2017-08-16.
//  Copyright © 2017 Kemin. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {

    @IBOutlet weak var suggestionTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var suggestions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the Yelp access token
        YelpClient.sharedInstance.getAccessToken { message in
            print(message)
        }
        
        let _ = LocationClient.sharedInstance
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        suggestionTableView.tableHeaderView = searchController.searchBar
    }
}

// MARK: -- Segues
extension SearchViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSearchResults", let indexPath = suggestionTableView.indexPathForSelectedRow {
            let keyword = suggestions[indexPath.row]
            let controller = segue.destination as! SearchResultViewController
            controller.keyword = keyword
        } else {
            
        }
    }
}

// MARK: -- TableView Delegate and Datasource
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

// MARK: -- SearchBar Delegate
extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let keyword = searchController.searchBar.text!
        
        YelpClient.sharedInstance.getAutoCompleteSuggestionsFor(keyword: keyword) { message, suggestions in
            self.suggestions = suggestions ?? []
            self.suggestionTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let searchResultViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController
        searchResultViewController.keyword = searchBar.text
        self.navigationController?.pushViewController(searchResultViewController, animated: true)
    }
}
