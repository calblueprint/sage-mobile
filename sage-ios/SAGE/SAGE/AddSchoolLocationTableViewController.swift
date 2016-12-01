//
//  AddSchoolLocationTableViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class AddSchoolLocationTableViewController: SGTableViewController {

    var autocompleteSuggestions: [GMSAutocompletePrediction] = [GMSAutocompletePrediction]()
    let placesClient: GMSPlacesClient = GMSPlacesClient.sharedClient()
    var locationView = AddSchoolLocationSelectorView()
    weak var parentVC: AddSchoolController?
    var rightMapButton = UIBarButtonItem()
    var rightSearchButton = UIBarButtonItem()
    
    init() {
        super.init(style: .Plain)
        self.rightMapButton = UIBarButtonItem(title: "Map", style: .Done, target: self, action: #selector(AddSchoolLocationTableViewController.returnToMap))
        self.rightSearchButton = UIBarButtonItem(title: "Search", style: .Done, target: self, action: #selector(AddSchoolLocationTableViewController.goToSearch))
        self.navigationItem.rightBarButtonItem = self.rightMapButton
        self.setNoContentMessage("No potential directors could be found.")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWithLocation(location: CLLocation) {
        self.locationView.configureWithLocation(location)
    }
    
    override func loadView() {
        self.view = self.locationView
        self.locationView.mapView.delegate = self
        self.locationView.tableView.dataSource = self
        self.locationView.tableView.delegate = self
        self.locationView.searchBar.delegate = self
    }
    
    func returnToMap() {
        self.locationView.mapView.alpha = 1.0
        UIView.animateWithDuration(UIConstants.fastAnimationTime) { () -> Void in
            self.locationView.tableView.alpha = 0.0
            self.locationView.searchBar.alpha = 0.0
        }
        self.locationView.mapView.userInteractionEnabled = true
        self.locationView.tableView.userInteractionEnabled = false
        self.locationView.searchBar.userInteractionEnabled = false
        self.navigationItem.rightBarButtonItem = self.rightSearchButton
    }
    
    func goToSearch() {
        self.locationView.tableView.alpha = 1.0
        self.locationView.searchBar.alpha = 1.0
        UIView.animateWithDuration(UIConstants.fastAnimationTime) { () -> Void in
            self.locationView.mapView.alpha = 0.0
        }
        self.locationView.mapView.userInteractionEnabled = false
        self.locationView.tableView.userInteractionEnabled = true
        self.locationView.searchBar.userInteractionEnabled = true
        self.navigationItem.rightBarButtonItem = self.rightMapButton
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeTitle("Search for Schools")
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
        var cell = self.locationView.tableView.dequeueReusableCellWithIdentifier("DefaultTableViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "DefaultTableViewCell")
        }
        let result = self.autocompleteSuggestions[indexPath.row]
        cell?.textLabel?.font = UIFont.normalFont
        cell!.textLabel?.attributedText = result.attributedFullText
        cell?.detailTextLabel?.font = UIFont.metaFont
        cell?.detailTextLabel?.textColor = UIColor.secondaryTextColor
        self.placesClient.lookUpPlaceID(result.placeID!) { (place, error) -> Void in
            cell?.detailTextLabel?.text = place?.formattedAddress
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.locationView.activityIndicator.startAnimating()
        let placeID = self.autocompleteSuggestions[indexPath.row].placeID
        let placeClient = GMSPlacesClient.sharedClient()
        placeClient.lookUpPlaceID(placeID!) { (predictedPlace, error) -> Void in
            if let place = predictedPlace {
                let coordinate = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                self.locationView.mapView.camera = GMSCameraPosition(target: coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
                self.parentVC?.didSelectPlace(place)
                self.locationView.activityIndicator.stopAnimating()
                self.returnToMap()
            }
        }
    }

}

//
// MARK: - UISearchBarDelegate
//
extension AddSchoolLocationTableViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.locationView.activityIndicator.startAnimating()
        self.locationView.activityIndicator.hidden = false
        
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

extension AddSchoolLocationTableViewController: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        let centerPoint = self.locationView.mapView.center
        let coordinate = self.locationView.mapView.projection.coordinateForPoint(centerPoint)
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { (placemarks, error) -> Void in
            
            if error == nil {
                if placemarks?.count > 0 {
                    let pm = placemarks![0]
                    self.parentVC?.selectPlacemarkData(pm, coordinate: coordinate)
                }
            }
        }
        self.parentVC?.didSelectCoordinate(coordinate)
    }
}


