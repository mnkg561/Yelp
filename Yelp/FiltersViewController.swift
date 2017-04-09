//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Mogulla, Naveen on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}


class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var originalFilters = [String: Array<Any>]()
    
    var tempWithDistanceFilters = [String: Array<Any>]()
    
    var tempWithSortByFilters = [String: Array<Any>]()
    
    var originalTempFilters = [String: Array<Any>]()
    
    var onScreenFilters = [String: Array<Any>]()
    
    var touchEvent:Bool = false
    
    var sortByTouchEvent: Bool = false
    
    var selectedDistance: String = ""
    var selectedSortBy: String = ""
    
    let sectionNames = ["Deals", "Distance", "Sort By", "Categories"]
    
    let distanceArray = ["", "0.3 miles", "0.5 miles", "5 miles", "15 miles"]
    let sortByArray = ["", "Best Match", "Distance", "High Rated" ]
    
    
    var categories: [[String: String]]!
    var switchStates = [Int: Bool]()
    
    let userDefaults = UserDefaults.standard
    
    weak var delegate: FiltersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        navigationController?.navigationBar.barTintColor = UIColor.red
        reloadData()
        self.onScreenFilters = self.originalFilters
        categories = yelpCategories()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.onScreenFilters.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        print(sectionNames[section])
        return sectionNames[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let valuesArray = self.onScreenFilters[sectionNames[section]]
        
        if section != 3 {
            return valuesArray!.count
        }else {
            return categories.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                self.touchEvent = true
                //reloadData()
                self.onScreenFilters = self.tempWithDistanceFilters
                self.tableView.reloadData()
            } else {
                self.touchEvent = false
                self.selectedDistance = distanceArray [indexPath.row]
                userDefaults.set(self.selectedDistance, forKey: "selectedDistance")
                print(selectedDistance)
                print(originalFilters)
                reloadData()
                self.onScreenFilters = self.originalFilters
                self.tableView.reloadData()
            }
            
        } else if indexPath.section == 2 {
            
            if indexPath.row == 0 {
                self.sortByTouchEvent = true
                //reloadData()
                self.onScreenFilters = self.tempWithSortByFilters
                self.tableView.reloadData()
            } else {
                self.sortByTouchEvent = false
                self.selectedSortBy = sortByArray[indexPath.row]
                userDefaults.set(self.selectedSortBy, forKey: "selectedSortBy")
                reloadData()
                self.onScreenFilters = self.originalFilters
                self.tableView.reloadData()
            }
        } else if indexPath.section == 0 || indexPath.section == 3 {
            
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(indexPath)
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        let valuesArray = self.onScreenFilters[sectionNames[indexPath.section]]
        cell.layer.cornerRadius = 6
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.delegate = self
        if indexPath.section == 3 {
            cell.switchLabel.text = categories[indexPath.row]["name"]
            cell.onSwitch.isOn = switchStates [indexPath.row] ?? false
            
        } else if indexPath.section != 3 {
            
            cell.switchLabel.text = valuesArray![indexPath.row] as? String
        }
        
        if indexPath.section == 1 || indexPath.section == 2 {
            cell.onSwitch.isHidden = true
        }
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                if self.touchEvent == true{
                    let image = UIImage(named: "checked")
                    let imageView = UIImageView(image: image)
                    cell.accessoryView = imageView
                } else {
                    let image = UIImage(named: "expand_arrow")
                    let imageView = UIImageView(image: image)
                    cell.accessoryView = imageView
                }
                
            } else {
                let image = UIImage(named: "Unchecked")
                let imageView = UIImageView(image: image)
                cell.accessoryView = imageView
            }
            
        } else if indexPath.section == 2 {
            
            if indexPath.row == 0 {
                if self.sortByTouchEvent == true{
                    let image = UIImage(named: "checked")
                    let imageView = UIImageView(image: image)
                    cell.accessoryView = imageView
                } else  {
                    let image = UIImage(named: "expand_arrow")
                    let imageView = UIImageView(image: image)
                    cell.accessoryView = imageView
                }
                
            } else {
                let image = UIImage(named: "Unchecked")
                let imageView = UIImageView(image: image)
                cell.accessoryView = imageView
            }
            
        }
        
        if indexPath.section == 0 || indexPath.section == 3 {
            cell.onSwitch.isHidden = false
            cell.accessoryView = nil
        }
        return cell
        
    }
    
    
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        switchStates[indexPath.row] = value
        
        
    }
    
    @IBAction func onCancelButtonClicked(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onSearchButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        var filters = [String: AnyObject]()
        
        filters["selectedSortBy"] = selectedSortBy as AnyObject
        
        
        var selectedCategories = [String]()
        for(row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject
        }
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
        
        userDefaults.set(selectedDistance, forKey: "selectedDistance")
        userDefaults.set(selectedSortBy, forKey: "selectedSortBy")
        //userDefaults.set(switchStates, forKey: "switchStates")
        
    }
    
    
    
    func reloadData() {
        
        if userDefaults.string(forKey: "selectedSortBy") == nil {
            
            self.selectedSortBy = "Best Match"
            userDefaults.set("Best Match", forKey: "selectedSortBy")
        } else {
            self.selectedSortBy = userDefaults.string(forKey: "selectedSortBy")!
        }
        
        if userDefaults.string(forKey: "selectedDistance") == nil {
            self.selectedDistance = "5 miles"
            userDefaults.set("5 miles", forKey: "selectedDistance")
        } else {
            self.selectedDistance = userDefaults.string(forKey: "selectedDistance")!
        }
        
        /*
         if userDefaults.array(forKey: "switchStates") != nil {
         self.switchStates = userDefaults.array(forKey: "switchStates") as! [Int: Bool]
         }
         */
        
        
        
        self.originalFilters = ["Deals": ["Offering a Deal"],
                                "Distance": [selectedDistance],
                                "Sort By": [selectedSortBy],
                                "categories": yelpCategories()]
        
        self.tempWithDistanceFilters = ["Deals": ["Offering a Deal"],
                                        "Distance": [selectedDistance, "0.3 miles", "0.5 miles", "5 miles", "15 miles"],
                                        "Sort By": [selectedSortBy],
                                        "categories": yelpCategories()]
        
        
        self.tempWithSortByFilters = ["Deals": ["Offering a Deal"],
                                      "Distance": [selectedDistance],
                                      "Sort By": [selectedSortBy, "Best Match", "Distance", "High Rated"],
                                      "categories": yelpCategories()]
        
        
        self.originalTempFilters = ["Deals": ["Offering a Deal"],
                                    "Distance": ["Auto", "0.3 miles", "0.5 miles", "5 miles", "15 miles"],
                                    "Sort By": ["Best Match", "Distance", "High Rated"],
                                    "categories": yelpCategories()]
        
    }
    
    
    
    func yelpCategories() -> [[String: String]]{
        return [["name" : "Afghan", "code": "afghani"],
                ["name" : "African", "code": "african"],
                ["name" : "American, New", "code": "newamerican"],
                ["name" : "American, Traditional", "code": "tradamerican"],
                ["name" : "Arabian", "code": "arabian"],
                ["name" : "Argentine", "code": "argentine"],
                ["name" : "Armenian", "code": "armenian"],
                ["name" : "Asian Fusion", "code": "asianfusion"],
                ["name" : "Asturian", "code": "asturian"],
                ["name" : "Australian", "code": "australian"],
                ["name" : "Austrian", "code": "austrian"],
                ["name" : "Baguettes", "code": "baguettes"],
                ["name" : "Bangladeshi", "code": "bangladeshi"],
                ["name" : "Barbeque", "code": "bbq"],
                ["name" : "Basque", "code": "basque"],
                ["name" : "Bavarian", "code": "bavarian"],
                ["name" : "Beer Garden", "code": "beergarden"],
                ["name" : "Beer Hall", "code": "beerhall"],
                ["name" : "Beisl", "code": "beisl"],
                ["name" : "Belgian", "code": "belgian"],
                ["name" : "Bistros", "code": "bistros"],
                ["name" : "Black Sea", "code": "blacksea"],
                ["name" : "Brasseries", "code": "brasseries"],
                ["name" : "Brazilian", "code": "brazilian"],
                ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                ["name" : "British", "code": "british"],
                ["name" : "Buffets", "code": "buffets"],
                ["name" : "Bulgarian", "code": "bulgarian"],
                ["name" : "Burgers", "code": "burgers"],
                ["name" : "Burmese", "code": "burmese"],
                ["name" : "Cafes", "code": "cafes"],
                ["name" : "Cafeteria", "code": "cafeteria"],
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
                ["name" : "Chilean", "code": "chilean"],
                ["name" : "Chinese", "code": "chinese"],
                ["name" : "Comfort Food", "code": "comfortfood"],
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
                ["name" : "German", "code": "german"],
                ["name" : "Giblets", "code": "giblets"],
                ["name" : "Gluten-Free", "code": "gluten_free"],
                ["name" : "Greek", "code": "greek"],
                ["name" : "Halal", "code": "halal"],
                ["name" : "Hawaiian", "code": "hawaiian"],
                ["name" : "Heuriger", "code": "heuriger"],
                ["name" : "Himalayan/Nepalese", "code": "himalayan"],
                ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
                ["name" : "Hot Dogs", "code": "hotdog"],
                ["name" : "Hot Pot", "code": "hotpot"],
                ["name" : "Hungarian", "code": "hungarian"],
                ["name" : "Iberian", "code": "iberian"],
                ["name" : "Indian", "code": "indpak"],
                ["name" : "Indonesian", "code": "indonesian"],
                ["name" : "International", "code": "international"],
                ["name" : "Irish", "code": "irish"],
                ["name" : "Island Pub", "code": "island_pub"],
                ["name" : "Israeli", "code": "israeli"],
                ["name" : "Italian", "code": "italian"],
                ["name" : "Japanese", "code": "japanese"],
                ["name" : "Jewish", "code": "jewish"],
                ["name" : "Kebab", "code": "kebab"],
                ["name" : "Korean", "code": "korean"],
                ["name" : "Kosher", "code": "kosher"],
                ["name" : "Kurdish", "code": "kurdish"],
                ["name" : "Laos", "code": "laos"],
                ["name" : "Laotian", "code": "laotian"],
                ["name" : "Latin American", "code": "latin"],
                ["name" : "Live/Raw Food", "code": "raw_food"],
                ["name" : "Lyonnais", "code": "lyonnais"],
                ["name" : "Malaysian", "code": "malaysian"],
                ["name" : "Meatballs", "code": "meatballs"],
                ["name" : "Mediterranean", "code": "mediterranean"],
                ["name" : "Mexican", "code": "mexican"],
                ["name" : "Middle Eastern", "code": "mideastern"],
                ["name" : "Milk Bars", "code": "milkbars"],
                ["name" : "Modern Australian", "code": "modern_australian"],
                ["name" : "Modern European", "code": "modern_european"],
                ["name" : "Mongolian", "code": "mongolian"],
                ["name" : "Moroccan", "code": "moroccan"],
                ["name" : "New Zealand", "code": "newzealand"],
                ["name" : "Night Food", "code": "nightfood"],
                ["name" : "Norcinerie", "code": "norcinerie"],
                ["name" : "Open Sandwiches", "code": "opensandwiches"],
                ["name" : "Oriental", "code": "oriental"],
                ["name" : "Pakistani", "code": "pakistani"],
                ["name" : "Parent Cafes", "code": "eltern_cafes"],
                ["name" : "Parma", "code": "parma"],
                ["name" : "Persian/Iranian", "code": "persian"],
                ["name" : "Peruvian", "code": "peruvian"],
                ["name" : "Pita", "code": "pita"],
                ["name" : "Pizza", "code": "pizza"],
                ["name" : "Polish", "code": "polish"],
                ["name" : "Portuguese", "code": "portuguese"],
                ["name" : "Potatoes", "code": "potatoes"],
                ["name" : "Poutineries", "code": "poutineries"],
                ["name" : "Pub Food", "code": "pubfood"],
                ["name" : "Rice", "code": "riceshop"],
                ["name" : "Romanian", "code": "romanian"],
                ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
                ["name" : "Rumanian", "code": "rumanian"],
                ["name" : "Russian", "code": "russian"],
                ["name" : "Salad", "code": "salad"],
                ["name" : "Sandwiches", "code": "sandwiches"],
                ["name" : "Scandinavian", "code": "scandinavian"],
                ["name" : "Scottish", "code": "scottish"],
                ["name" : "Seafood", "code": "seafood"],
                ["name" : "Serbo Croatian", "code": "serbocroatian"],
                ["name" : "Signature Cuisine", "code": "signature_cuisine"],
                ["name" : "Singaporean", "code": "singaporean"],
                ["name" : "Slovakian", "code": "slovakian"],
                ["name" : "Soul Food", "code": "soulfood"],
                ["name" : "Soup", "code": "soup"],
                ["name" : "Southern", "code": "southern"],
                ["name" : "Spanish", "code": "spanish"],
                ["name" : "Steakhouses", "code": "steak"],
                ["name" : "Sushi Bars", "code": "sushi"],
                ["name" : "Swabian", "code": "swabian"],
                ["name" : "Swedish", "code": "swedish"],
                ["name" : "Swiss Food", "code": "swissfood"],
                ["name" : "Tabernas", "code": "tabernas"],
                ["name" : "Taiwanese", "code": "taiwanese"],
                ["name" : "Tapas Bars", "code": "tapas"],
                ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
                ["name" : "Tex-Mex", "code": "tex-mex"],
                ["name" : "Thai", "code": "thai"],
                ["name" : "Traditional Norwegian", "code": "norwegian"],
                ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                ["name" : "Trattorie", "code": "trattorie"],
                ["name" : "Turkish", "code": "turkish"],
                ["name" : "Ukrainian", "code": "ukrainian"],
                ["name" : "Uzbek", "code": "uzbek"],
                ["name" : "Vegan", "code": "vegan"],
                ["name" : "Vegetarian", "code": "vegetarian"],
                ["name" : "Venison", "code": "venison"],
                ["name" : "Vietnamese", "code": "vietnamese"],
                ["name" : "Wok", "code": "wok"],
                ["name" : "Wraps", "code": "wraps"],
                ["name" : "Yugoslav", "code": "yugoslav"]]    }
}
