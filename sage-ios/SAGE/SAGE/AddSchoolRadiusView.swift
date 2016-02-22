//
//  AddSchoolRadiusView.swift
//  SAGE
//
//  Created by Erica Yin on 2/21/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class AddSchoolRadiusView: UIView {
    
    let leftMargin = CGFloat(35.0)
    let sliderHeight = CGFloat(45.0)
    let maximumRadius = Float(700.0)
    let defaultRadius = Float(350.0)
    var mapView: GMSMapView = GMSMapView()
    var radiusCenter = CLLocationCoordinate2D()
    var slider = UISlider()
    var radiusLabel = UILabel()
    var circle = GMSCircle()

    init(frame: CGRect, center: CLLocationCoordinate2D) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.radiusCenter = center
        self.slider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func sliderValueDidChange(sender: UISlider!) {
        print("value--\(self.slider.value)")
        let value = sender.value
        var index = 1
        if (value >= 10 && value < 100) {
            index = 2
        } else if (value >= 100) {
            index = 3
        }
        let roundedValueString: String = (String(sender.value) as NSString).substringToIndex(index)
        self.radiusLabel.text = roundedValueString + " meters"
        self.radiusLabel.sizeToFit()
        if self.slider.value > 5 {
            self.circle.radius = CLLocationDistance(self.slider.value)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.mapView.fillWidth()
        self.mapView.fillHeight()
        
        self.slider.fillWidthWithMargin(self.leftMargin)
        self.slider.setHeight(self.sliderHeight)
        self.slider.centerHorizontally()
        self.slider.setY(CGRectGetMaxY(self.mapView.frame) - self.sliderHeight - UIConstants.sideMargin)
        
        self.radiusLabel.sizeToFit()
        self.radiusLabel.setX(self.leftMargin)
        self.radiusLabel.setY(CGRectGetMinY(self.slider.frame) - 15.0)
    }
    
    private func setupSubviews() {
        self.addSubview(self.mapView)
        self.addSubview(self.slider)
        self.addSubview(self.radiusLabel)
        
        self.mapView.mapType = kGMSTypeHybrid
        
        self.slider.minimumValue = 0
        self.slider.maximumValue = self.maximumRadius
        self.slider.continuous = true
        self.slider.tintColor = UIColor.lightBlueColor
        self.slider.value = self.defaultRadius
        
        self.radiusLabel.font = UIFont.normalFont
        self.radiusLabel.text = "200 meters"
        
        let marker = GMSMarker(position: self.radiusCenter)
        marker.map = self.mapView
        self.mapView.camera = GMSCameraPosition(target: self.radiusCenter, zoom: 15, bearing: 0, viewingAngle: 0)
        
        let circleCenter = self.radiusCenter
        self.circle.fillColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.25)
        self.circle.strokeColor = UIColor.whiteColor()
        self.circle.strokeWidth = 1
        self.circle.position = circleCenter
        self.circle.radius = CLLocationDistance(self.slider.value)
        self.circle.map = self.mapView
    }

}
