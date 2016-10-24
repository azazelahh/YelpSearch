//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Olya Sorokina on 10/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    
    func filtersViewController (filtersViewController: FiltersViewController, didUpdateFilters filters: Preferences)
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
    SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    
    var currentPreferences: Preferences!
    
    var sections: [Section] = FiltersViewController.makeSections()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initSectionData(preferences: currentPreferences)
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    private static func makeSections() -> [Section] {
        
        let dealSection = Section(name: "", multiselect: false)
        dealSection.contents.append(Filter(name: "Offering a Deal"))
        
        let distanceSection = Section(name: "Distance", multiselect: false)
        distanceSection.contents.append(Filter(name: "Best Match"))
        distanceSection.contents.append(Filter(name: "0.3 miles"))
        distanceSection.contents.append(Filter(name: "1 mile"))
        distanceSection.contents.append(Filter(name: "5 miles"))
        distanceSection.contents.append(Filter(name: "20 miles"))
        
        let sortSection = Section(name: "Sort By", multiselect: false)
        sortSection.contents.append(Filter(name: "Best Match"))
        sortSection.contents.append(Filter(name: "Distance"))
        sortSection.contents.append(Filter(name: "Rating"))
        
        let categorySection = Section(name: "Category", multiselect: true)
        let categories = FiltersViewController.yelpCategories()
        for category in categories {
            categorySection.contents.append(Filter(name: category["name"]!))
        }
        
        return [dealSection, distanceSection, sortSection, categorySection]
        
    }
    
    private func initSectionData(preferences: Preferences) {
        NSLog("Here")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButtonTap(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearchButtonTap(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        
        self.currentPreferences.deals = sections[0].contents[0].isOn
        self.currentPreferences.distance = getDistance()
        self.currentPreferences.sort = getSort()
        self.currentPreferences.categories = getCategories()
        
        delegate?.filtersViewController(filtersViewController: self, didUpdateFilters: currentPreferences)
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].name
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].contents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        
        let section = sections[indexPath.section]
        let sectionRow = section.contents[indexPath.row]
        cell.switchLabel.text = sectionRow.name
        cell.delegate = self
        
        cell.onSwitch.isOn = sectionRow.isOn
        
        return cell
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        
        let section = sections[indexPath.section]
        section.filterDidChangeValue(row: indexPath.row, value: value)
        
        tableView.reloadData()
        
    }
    
    private func getDistance() -> Int? {
        let filter = sections[1].contents.first(where: {$0.isOn})
        
        switch filter?.name {
            case "Best Match"?: return nil
            case "0.3 miles"?: return 483
            case "1 mile"?: return 16095
            case "5 miles"?: return 8047
            case "20 miles"?: return 32187
            default: return nil
        }
    }
    
    private func getSort() -> YelpSortMode? {
        let filter = sections[2].contents.first(where: {$0.isOn})
        
        switch filter?.name {
        case "Best Match"?: return YelpSortMode.bestMatched
        case "Distance"?: return YelpSortMode.distance
        case "Rating"?: return YelpSortMode.highestRated
        default: return nil
        }
    }
    
    private func getCategories() -> [String]? {
        let filters = sections[3].contents.filter({ $0.isOn })
        var categories = [String]()
        
        for filter in filters {
            categories.append(filter.name)
        }
        
        return categories
    }
    
    static func yelpCategories() -> [[String:String]] {
        return [["name" : "Afghan", "code": "afghani"],
            ["name" : "African", "code": "african"],
            ["name" : "American, New", "code": "newamerican"],
            ["name" : "American, Traditional", "code": "tradamerican"],
            ["name" : "Arabian", "code": "arabian"],
            ["name" : "Argentine", "code": "argentine"],
            ["name" : "Armenian", "code": "armenian"],
            ["name" : "Asian Fusion", "code": "asianfusion"],
            ["name" : "Asturian", "code": "asturian"],
            ["name" : "Australian", "code": "Australian"],
            ["name" : "Austrian", "code": "Austrian"],
            ["name" : "Baguettes", "code": "baguettes"],
            ["name" : "Bangladeshi", "code": "bangladeshi"],
            ["name" : "Barbeque", "code": "bbq"],
            ["name" : "Bavarian", "code": "bavarian"],
            ["name" : "Basque", "code": "basque"],
            ["name" : "Beer Garden", "code": "beergarden"],
            ["name" : "Beer Hall", "code": "beerhall"],
            ["name" : "Beisl", "code": "beisl"],
            ["name" : "Belgian", "code": "belgian"],
            ["name" : "Bulgarian", "code": "bulgarian"],
            ["name" : "Burgers", "code": "burgers"],
            ["name" : "Cafes", "code": "cafes"],
            ["name" : "Cafeteria", "code": "Cafeteria"],
            ["name" : "Cajun/Creole", "code": "cajun"],
            ["name" : "Cambodian", "code": "cambodian"],
            ["name" : "Canadian", "code": "New)"],
            ["name" : "Canteen", "code": "canteen"],
            ["name" : "Caribbean", "code": "caribbean"],
            ["name" : "Catalan", "code": "catalan"],
            ["name" : "Chech", "code": "chech"],
            ["name" : "Cheesesteaks", "code": "cheesesteaks"],
            ["name" : "Chicken Shop", "code": "chickenshop"],
            ["name" : "Chicken Wings", "code": "chicken_wings"],
            ["name" : "chilean", "code": "chilean"],
            ["name" : "Chinese", "code": "chinese"],
            ["name" : "Comfort Food", "code": "comformfood"],
            ["name" : "Corsican", "code": "corsican"],
            ["name" : "Creperies", "code": "creperies"],
            ["name" : "Cuban", "code": "cuban"],
            ["name" : "Curry Sausage", "code": "currysausage"],
            ["name" : "Cypriot", "code": "cypriot"],
            ["name" : "Czech", "code": "czech"],
            ["name" : "Czech/Slovakian", "code": "czechslovakian"],
            ["name" : "Danish", "code": "danish"],
            ["name" : "Delis", "code": "delis"],
            ["name" : "Diners", "code": "diners"],
            ["name" : "Dumplings", "code": "dumplings"],
            ["name" : "Eastern European", "code": "eastern_european"],
            ["name" : "Ethiopian", "code": "ethiopian"],
            ["name" : "Fast Food", "code": "hotdogs"],
            ["name" : "Filipino", "code": "filipino"],
            ["name" : "Fish & Chips", "code": "fishnchips"],
            ["name" : "Fondue", "code": "fondue"],
            ["name" : "Food Court", "code": "food_court"],
            ["name" : "Food Stands", "code": "foodstands"],
            ["name" : "French", "code": "french"],
            ["name" : "French Southwest", "code": "sud_ouest"],
            ["name" : "Galician", "code": "galician"],
            ["name" : "Gastropubs", "code": "gastropubs"],
            ["name" : "Georgian", "code": "georgian"],
            ["name" : "German", "code": "German"]
        ]
    }

}
