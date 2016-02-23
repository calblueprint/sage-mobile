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
    var marker = GMSMarker()
    
    weak var parentVC: AddSchoolController?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWithLocation(location: CLLocation) {
        self.locationView.configureWithLocation(location)
        self.placeMarkerAt(location.coordinate)
    }
    
    override func loadView() {
        self.view = self.locationView
        self.locationView.mapView.delegate = self
        self.placeMarkerAt(CLLocationCoordinate2D(latitude: 0, longitude: 0))
        self.locationView.tableView.dataSource = self
        self.locationView.tableView.delegate = self
        self.locationView.searchBar.delegate = self
        self.locationView.returnToMapButton.addTarget(self, action: "returnToMap", forControlEvents: .TouchUpInside)
    }
    
    func placeMarkerAt(coordinate: CLLocationCoordinate2D) {
        self.marker.map = nil
        self.marker = GMSMarker(position: coordinate)
        self.marker.map = self.locationView.mapView
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
        self.locationView.activityIndicator.startAnimating()
        let placeID = self.autocompleteSuggestions[indexPath.row].placeID
        let placeClient = GMSPlacesClient.sharedClient()
        placeClient.lookUpPlaceID(placeID) { (predictedPlace, error) -> Void in
            if let place = predictedPlace {
                let coordinate = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                self.locationView.mapView.camera = GMSCameraPosition(target: coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
                self.parentVC?.didSelectPlace(place)
                self.locationView.activityIndicator.stopAnimating()
                self.locationView.mapView.hidden = false
                self.locationView.tableView.hidden = true
            }
        }
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

extension AddSchoolLocationSelectorController: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
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
    
    func mapView(mapView: GMSMapView!, didChangeCameraPosition position: GMSCameraPosition!) {
        let centerPoint = self.locationView.mapView.center
        let coordinate = self.locationView.mapView.projection.coordinateForPoint(centerPoint)
        self.placeMarkerAt(coordinate)
    }
}


