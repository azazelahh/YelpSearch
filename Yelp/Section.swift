//
//  Section.swift
//  Yelp
//
//  Created by Olya Sorokina on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class Section: NSObject {
    
    var name: String!
    var contents: [Filter]! = []
    var allowsMultiselect: Bool = false
    var isExpanded: Bool?
    
    init(name: String, multiselect: Bool) {
        super.init()
        
        self.name = name
        self.allowsMultiselect = multiselect
        
    }
    
    func getNumberOfRows() -> Int {
        
        if(isExpanded!) {
            return contents.count
        } else {
            return 1
        }
    }
    
    func filterDidChangeValue(row: Int, value: Bool)
    {
        if (self.allowsMultiselect) {
            self.contents[row].isOn = value
        } else if (value) {
            self.contents[row].isOn = value
    
            for (index, filter) in contents.enumerated() {
                if (index != row) {
                    filter.isOn = false
                }
            }
        }
    }
}
