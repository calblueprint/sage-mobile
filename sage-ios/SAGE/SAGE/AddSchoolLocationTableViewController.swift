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
    
    weak var parentVC: AddSchoolController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search for Schools"
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
        var cell = self.tableView.dequeueReusableCellWithIdentifier("DefaultTableViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "DefaultTableViewCell")
        }
        let result = self.autocompleteSuggestions[indexPath.row]
        cell?.textLabel?.font = UIFont.normalFont
        cell!.textLabel?.attributedText = result.attributedFullText
        cell?.detailTextLabel?.font = UIFont.metaFont
        cell?.detailTextLabel?.textColor = UIColor.secondaryTextColor
        self.placesClient.lookUpPlaceID(result.placeID) { (place, error) -> Void in
            cell?.detailTextLabel?.text = place?.formattedAddress
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.parentVC?.didSelectPlace(self.autocompleteSuggestions[indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
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
        filter.type = GMSPlacesAutocompleteTypeFilter.Establishment
        
        self.placesClient.autocompleteQuery(searchText, bounds: nil, filter: filter, callback: { (results, error: NSError?) -> Void in
            if error == nil {
                self.autocompleteSuggestions = [GMSAutocompletePrediction]()
                for result in results! {
                    if let result = result as? GMSAutocompletePrediction {
                        self.autocompleteSuggestions.append(result)
                    }
                }
                self.tableView.reloadData()
            } else {
                
            }
            self.activityIndicator.stopAnimating()
        })
    }
    
}


