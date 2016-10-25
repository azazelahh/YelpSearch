//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
    FiltersViewControllerDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchBar = UISearchBar()
    var businesses: [Business]!
    var isMoreDataLoading = false
    let itemLimit: Int = 20
    var itemOffset: Int = 0
    
    var preferences: Preferences = Preferences() {
        didSet {
            itemOffset = 0
            searchWithPreferences(isNewSearch: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        createSearchBar()
        
        self.preferences = Preferences()
    }
    
    private func searchWithPreferences(isNewSearch: Bool) {
        let categories = self.preferences.getYelpCategories()
        let term = self.preferences.term!
        let sort = self.preferences.getYelpSortMode()
        let deals = self.preferences.getYelpDeals()
        let distance = self.preferences.getYelpDistance()
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Business.searchWithTerm(term: term, sort: sort, categories: categories, deals: deals, distance: distance, limit: itemLimit, offset: itemOffset, completion: {(businesses: [Business]?, error: Error?) -> Void in
            if error != nil {
                NSLog(error.debugDescription)
            }
            if (isNewSearch) {
                self.businesses = businesses
            } else {
                self.businesses!.append(contentsOf: businesses!)
            }
            self.tableView.reloadData()
            self.isMoreDataLoading = false
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
//            if let businesses = businesses {
//                for business in businesses {
//                    print(business.name!)
//                    print(business.address!)
//                }
//            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if businesses != nil {
            return businesses!.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "preferencesSegue" {
            
            let navigationController = segue.destination as! UINavigationController
            let filtersViewController = navigationController.topViewController as! FiltersViewController
            filtersViewController.currentPreferences = preferences
            filtersViewController.delegate = self
        }
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: Preferences) {
        self.preferences = filters
    }
    
    ///
    /// Search
    ///
    func createSearchBar()
    {
        searchBar.placeholder = "Enter search terms here"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        itemOffset = 0
        searchWithPreferences(isNewSearch: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.preferences.term = searchText
    }
    
    ///
    /// Infinite Scroll
    ///
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height*1.5
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoading = true
                loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        
        itemOffset += 20
        searchWithPreferences(isNewSearch: false)
    }
}
