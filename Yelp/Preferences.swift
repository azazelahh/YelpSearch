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
    var sort: YelpSortMode?
    var categories: [String]?
    var deals: Bool?
    var distance: Int?
    
    override init() {
        self.term = "Restaurants"
        self.sort = nil
        self.categories = nil
        self.deals = nil
        self.distance = nil
    }
    
}
