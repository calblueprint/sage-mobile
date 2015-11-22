//
//  AddSchoolLocationTableViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class AddSchoolLocationTableViewController: UITableViewController {

    var autocompleteSuggestions: [GMSAutocompletePrediction] = [GMSAutocompletePrediction]()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    let placesClient: GMSPlacesClient = GMSPlacesClient.sharedClient()
    
    override func viewDidLoad() {
        self.title = "Enter Address"
        super.viewDidLoad()
        let searchBar = UISearchBar()
        searchBar.setHeight(44)
        searchBar.tintColor = UIColor.whiteColor()
        searchBar.backgroundColor = UIColor.mainColor
        searchBar.barTintColor = UIColor.whiteColor()
        searchBar.searchBarStyle = .Minimal
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar
        
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.hidden = true
        
        self.tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return autocompleteSuggestions.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DefaultTableViewCell", forIndexPath: indexPath)
        let result = self.autocompleteSuggestions[indexPath.row]
        cell.textLabel?.attributedText = result.attributedFullText
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let parentVC = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2] as! AddSchoolController
        parentVC.didSelectPlace(self.autocompleteSuggestions[indexPath.row])
        self.navigationController!.popViewControllerAnimated(true)
    }

}

//
// MARK: - UISearchBarDelegate
//
extension AddSchoolLocationTableViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.activityIndicator.centerHorizontally()
        self.activityIndicator.centerVertically()
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidden = false
        
        let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.Region
        
        self.placesClient.autocompleteQuery(searchText, bounds: nil, filter: filter, callback: { (results, error: NSError?) -> Void in
            
            for result in results! {
                if let result = result as? GMSAutocompletePrediction {
                    self.autocompleteSuggestions.append(result)
                }
            }
            self.tableView.reloadData()
        })
    }
    
}


