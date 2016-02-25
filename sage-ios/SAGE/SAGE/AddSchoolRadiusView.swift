//
//  AddSchoolRadiusView.swift
//  SAGE
//
//  Created by Erica Yin on 2/21/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class AddSchoolRadiusView: UIView {

    let leftMargin = CGFloat(35)
    let sliderHeight = CGFloat(45)
    let maximumRadius = Float(700)
    var mapView: GMSMapView = GMSMapView()
    var circle = GMSCircle()
    var radiusCenter = CLLocationCoordinate2D()
    var radius = CLLocationDistance(200)
    var sliderView = UIView()
    var slider = UISlider()
    var radiusLabel = UILabel()

    init(frame: CGRect, center: CLLocationCoordinate2D, radius: CLLocationDistance?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.radiusCenter = center
        if radius != nil {
            self.radius = radius!
        }
        self.slider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        self.setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func radiusToString(radius: Float) -> String {
        var index = 1
        if (radius >= 10 && radius < 100) {
            index = 2
        } else if (radius >= 100) {
            index = 3
        }
        let roundedValueString: String = (String(radius) as NSString).substringToIndex(index)
        return roundedValueString + " meters"
    }

    func sliderValueDidChange(sender: UISlider!) {
        self.radiusLabel.text = radiusToString(sender.value)
        self.radiusLabel.sizeToFit()
        if self.slider.value > 5 {
            self.circle.radius = CLLocationDistance(self.slider.value)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.mapView.fillWidth()
        self.mapView.fillHeight()

        self.sliderView.fillWidth()
        self.sliderView.setHeight(self.sliderHeight + 10)
        self.sliderView.centerHorizontally()
        self.sliderView.setY(CGRectGetMaxY(self.mapView.frame) - CGRectGetHeight(self.sliderView.frame))

        self.radiusLabel.setX(self.leftMargin)
        self.radiusLabel.centerVertically()
        self.radiusLabel.sizeToFit()

        self.slider.setX(CGRectGetMaxX(self.radiusLabel.frame) + UIConstants.sideMargin)
        self.slider.centerVertically()
        self.slider.setHeight(self.sliderHeight)
        self.slider.setWidth(CGRectGetWidth(self.sliderView.frame) - CGRectGetMinX(self.slider.frame) - self.leftMargin)
    }

    private func setupSubviews() {
        self.addSubview(self.mapView)
        self.addSubview(self.sliderView)
        self.sliderView.addSubview(self.slider)
        self.sliderView.addSubview(self.radiusLabel)

        self.sliderView.backgroundColor = UIColor.whiteColor()

        self.slider.minimumValue = 0
        self.slider.maximumValue = self.maximumRadius
        self.slider.continuous = true
        self.slider.tintColor = UIColor.lightBlueColor
        self.slider.value = Float(self.radius)

        self.radiusLabel.font = UIFont.normalFont
        self.radiusLabel.text = radiusToString(self.slider.value)

        let marker = GMSMarker(position: self.radiusCenter)
        marker.map = self.mapView
        self.mapView.camera = GMSCameraPosition(target: self.radiusCenter, zoom: 15, bearing: 0, viewingAngle: 0)

        let circleCenter = self.radiusCenter
        self.circle.fillColor = UIColor.colorWithIntRed(74, green: 144, blue: 226, alpha: 0.15)
        self.circle.strokeColor = UIColor.lightBlueColor
        self.circle.strokeWidth = 1
        self.circle.position = circleCenter
        self.circle.radius = CLLocationDistance(self.slider.value)
        self.circle.map = self.mapView
    }

}
