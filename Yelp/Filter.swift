//
//  Filter.swift
//  Yelp
//
//  Created by Olya Sorokina on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class Filter: NSObject {
    
    var name: String!
    var isOn: Bool! = false
    var yelpData: AnyObject?
    
    init (name: String, yelpData: AnyObject?) {
        self.name = name
        self.yelpData = yelpData
    }
    
}
