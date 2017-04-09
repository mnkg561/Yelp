//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
     var businesses: [Business]!
     var businessNames: [String] = []
    var originalBusinesses:[Business]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = "Restaurants"
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        navigationController?.navigationBar.barTintColor = UIColor.red
        
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.originalBusinesses = self.businesses
             self.tableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                   self.businessNames.append(business.name as! String)
                }
            }
            
            
            
            }
        )
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
           return businesses!.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
    
        cell.business = businesses[indexPath.row]
       
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        var searchBusinessResults: [Business] = []
        
        let filteredString = businessNames.filter { (item: String) -> Bool in
            let stringMatch = item.lowercased().range(of: searchText.lowercased())
            //var stringMatch = item.lowercased().contains("m")
            return stringMatch != nil ? true : false
        }
        print(filteredString)
        
        for business in self.businesses {
            for name in filteredString {
                if name.contains (business.name as! String) && !searchBusinessResults.contains(business){
                    searchBusinessResults.append(business)
                }
            }
            
        }
        if (!searchText.isEmpty){
            self.businesses = searchBusinessResults
        } else{
            self.businesses = self.originalBusinesses // Load the original movie results if search bar is empty
        }
        
        
        self.tableView.reloadData()
        
        
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }
    
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        var categories = filters["categories"] as? [String]
        //var sortBy = filters["selectedSortBy"] as! String
        Business.searchWithTerm(term: "Restaurents", sort: nil, categories: categories, deals: nil) { (businesses: [Business]?, error: Error?) in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
   
    
}
