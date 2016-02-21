//
//  AddSchoolRadiusView.swift
//  SAGE
//
//  Created by Erica Yin on 2/21/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class AddSchoolRadiusView: UIView {

    let sliderHeight = CGFloat(45.0)
    var mapView: GMSMapView = GMSMapView()
    var radiusCenter = CLLocationCoordinate2D()
    var slider = UISlider()

    init(frame: CGRect, center: CLLocationCoordinate2D) {
        super.init(frame: frame)
        self.radiusCenter = center
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

        self.slider.fillWidthWithMargin(35.0)
        self.slider.setHeight(self.sliderHeight)
        self.slider.centerHorizontally()
        self.slider.setY(CGRectGetMaxY(self.mapView.frame) - self.sliderHeight - UIConstants.sideMargin)
    }

    private func setupSubviews() {
        self.addSubview(self.mapView)
        self.addSubview(self.slider)
        self.slider.minimumValue = 0
        self.slider.maximumValue = 400
        self.slider.continuous = true
        self.slider.tintColor = UIColor.lightBlueColor
        self.slider.value = 200

        let marker = GMSMarker(position: self.radiusCenter)
        marker.map = self.mapView
        self.mapView.camera = GMSCameraPosition(target: self.radiusCenter, zoom: 15, bearing: 0, viewingAngle: 0)
    }

}
