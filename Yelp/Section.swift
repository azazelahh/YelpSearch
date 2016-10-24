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
    
    init(name: String, multiselect: Bool) {
        super.init()
        
        self.name = name
        self.allowsMultiselect = multiselect
        
    }
    
    func filterDidChangeValue(row: Int, value: Bool)
    {
        if (value) {
            self.contents[row].isOn = value
        
            if (!self.allowsMultiselect) {
            
                for (index, filter) in contents.enumerated() {
                    if (index != row) {
                        filter.isOn = false
                    }
                }
            }
        }
    }
}
