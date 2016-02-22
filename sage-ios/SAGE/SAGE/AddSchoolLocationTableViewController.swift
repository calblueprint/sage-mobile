//
//  AddSchoolLocationTableViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class AddSchoolLocationSelectorController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var autocompleteSuggestions: [GMSAutocompletePrediction] = [GMSAutocompletePrediction]()
    let placesClient: GMSPlacesClient = GMSPlacesClient.sharedClient()
    var locationView = AddSchoolLocationSelectorView()
    var school: School?
    
    weak var parentVC: AddSchoolController?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWithSchool(school: School) {
        self.school = school
        self.locationView.configureWithSchool(school)
    }
    
    override func loadView() {
        self.view = self.locationView
        self.locationView.tableView.dataSource = self
        self.locationView.tableView.delegate = self
        self.locationView.searchBar.delegate = self
        self.locationView.returnToMapButton.addTarget(self, action: "returnToMap", forControlEvents: .TouchUpInside)
    }
    
    func returnToMap() {
        self.locationView.mapView.hidden = false
        self.locationView.tableView.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search for Schools"
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return autocompleteSuggestions.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.locationView.tableView.dequeueReusableCellWithIdentifier("DefaultTableViewCell")
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.parentVC?.didSelectPlace(self.autocompleteSuggestions[indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
    }

}

//
// MARK: - UISearchBarDelegate
//
extension AddSchoolLocationSelectorController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.locationView.activityIndicator.startAnimating()
        self.locationView.activityIndicator.hidden = false
        self.locationView.tableView.hidden = false
        self.locationView.mapView.hidden = true
        
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
                self.locationView.tableView.reloadData()
            } else {
                
            }
            self.locationView.activityIndicator.stopAnimating()
        })
    }
}


