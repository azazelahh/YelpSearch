//
//  YelpSearchSettings.swift
//  Yelp
//
//  Created by Olya Sorokina on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import Foundation

class Preferences: NSObject {
    
    var term: String?
    var sort: Filter?
    var categories: [Filter]?
    var deals: Filter?
    var distance: Filter?
    
    override init() {
        self.term = "Restaurants"
        self.sort = nil
        self.categories = nil
        self.deals = nil
        self.distance = nil
    }
    
    func getYelpSortMode() -> YelpSortMode? {
        return sort?.yelpData as? YelpSortMode
    }
    
    func getYelpCategories() -> [String] {
        if categories == nil {
            return []
        } else {
            var selectedCategories: [String] = []
            for category in categories! {
                selectedCategories.append(category.yelpData as! String)
            }
            return selectedCategories
        }
    }
    
    func getYelpDeals() -> Bool {
        if deals != nil {
            return (deals?.isOn)!
        }
        return false
    }
    
    func getYelpDistance() -> Int? {
        return distance?.yelpData as? Int
    }
}
