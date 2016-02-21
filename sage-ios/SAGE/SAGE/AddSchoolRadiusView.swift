//
//  AddSchoolRadiusView.swift
//  SAGE
//
//  Created by Erica Yin on 2/21/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class AddSchoolRadiusView: UIView {

    var mapView: GMSMapView = GMSMapView()

    init(frame: CGRect, center: CLLocationCoordinate2D) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.mapView.fillWidth()
        self.mapView.fillHeight()
    }

    private func setupSubviews() {
        self.addSubview(self.mapView)

//        let marker = GMSMarker(position: self.school!.location!.coordinate)
//        marker.map = self.schoolDetailHeaderView.mapView
//        self.schoolDetailHeaderView.mapView.camera = GMSCameraPosition(target: self.school!.location!.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
    }

}
