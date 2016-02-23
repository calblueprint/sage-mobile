//
//  AddSchoolLocationSelectorView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 2/20/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

class AddSchoolLocationSelectorView: UIView {
    
    var tableView = UITableView()
    var mapView = GMSMapView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    var searchBar = UISearchBar()
    var returnToMapButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    func setupSubviews() {
        self.addSubview(self.tableView)
        self.tableView.hidden = true
        self.tableView.tableFooterView = UIView()
        
        self.returnToMapButton.setTitle("Return to map", forState: .Normal)
        self.returnToMapButton.setTitleColor(UIColor.lightBlueColor, forState: .Normal)
        self.returnToMapButton.titleLabel?.font = UIFont.normalFont
        self.addSubview(self.returnToMapButton)
        
        self.addSubview(self.mapView)
        self.mapView.camera = GMSCameraPosition(target: CLLocationCoordinate2DMake(0, 0), zoom: 15, bearing: 0, viewingAngle: 0)
        
        self.searchBar.setHeight(44)
        self.searchBar.tintColor = UIColor.whiteColor()
        self.searchBar.backgroundColor = UIColor.mainColor
        self.searchBar.barTintColor = UIColor.whiteColor()
        self.searchBar.searchBarStyle = .Minimal
        self.addSubview(self.searchBar)
        
        self.addSubview(self.activityIndicator)
        self.activityIndicator.hidden = true
    }
    
    func configureWithLocation(location: CLLocation) {
        self.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
    }
    
    override func layoutSubviews() {
        self.tableView.fillWidth()
        self.tableView.fillHeight()
        
        self.mapView.fillHeight()
        self.mapView.fillWidth()
        
        self.searchBar.fillWidth()
        self.searchBar.setHeight(44.0)
        
        self.activityIndicator.centerHorizontally()
        self.activityIndicator.centerVertically()
        
        self.returnToMapButton.sizeToFit()
        self.returnToMapButton.centerHorizontally()
        self.returnToMapButton.setHeight(44)
        self.returnToMapButton.setY(CGRectGetMaxY(self.frame) - 80)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
