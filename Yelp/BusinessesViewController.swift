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
    FiltersViewControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchBar = UISearchBar()
    
    var businesses: [Business]!
    var originalBusinesses: [Business]!
    
    var preferences: Preferences = Preferences() {
        didSet {
            applyPreferences()
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
    
    private func applyPreferences() {
        let categories = self.preferences.categories
        let term = self.preferences.term!
        let sort = self.preferences.sort
        let deals = self.preferences.deals
        let distance = self.preferences.distance
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Business.searchWithTerm(term: term, sort: sort, categories: categories, deals: deals, distance: distance, completion: {(businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.originalBusinesses = businesses
            self.tableView.reloadData()
            
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
    ///Search Implementation
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
        applyPreferences()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.preferences.term = searchText
    }
}
