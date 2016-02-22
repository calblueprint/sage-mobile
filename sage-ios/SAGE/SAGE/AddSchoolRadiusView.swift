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
    var mapView: GMSMapView = GMSMapView()
    var circle = GMSCircle()
    var radiusCenter = CLLocationCoordinate2D()
    var radius = CLLocationDistance()
    var sliderView = UIView()
    var slider = UISlider()
    var radiusLabel = UILabel()
    
    init(frame: CGRect, center: CLLocationCoordinate2D, radius: CLLocationDistance?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.radiusCenter = center
        if let radiusValue = radius {
            self.radius = radiusValue
        } else {
            self.radius = CLLocationDistance(200)
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
        print("value--\(self.slider.value)")
        let radiusLabelString = radiusToString(sender.value)
        self.radiusLabel.text = radiusLabelString
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
        self.sliderView.setHeight(self.sliderHeight + 20)
        self.sliderView.centerHorizontally()
        self.sliderView.setY(CGRectGetMaxY(self.mapView.frame) - CGRectGetHeight(self.sliderView.frame))
        
        self.sliderView.backgroundColor = UIColor.whiteColor()
        
//        let gradient: CAGradientLayer = CAGradientLayer()
//        gradient.frame = self.sliderView.bounds
//        gradient.colors = [UIColor.whiteColor().colorWithAlphaComponent(0).CGColor, UIColor.whiteColor().colorWithAlphaComponent(0.65).CGColor]
//        self.sliderView.layer.insertSublayer(gradient, atIndex: 0)
        
        self.slider.fillWidthWithMargin(self.leftMargin)
        self.slider.setHeight(self.sliderHeight)
        self.slider.centerInSuperview()
        self.slider.setY(CGRectGetMinY(self.slider.frame) + 10)
        
        self.radiusLabel.sizeToFit()
        self.radiusLabel.setX(self.leftMargin)
        self.radiusLabel.setY(CGRectGetMinY(self.slider.frame) - 12)
    }
    
    private func setupSubviews() {
        self.addSubview(self.mapView)
        self.addSubview(self.sliderView)
        self.sliderView.addSubview(self.slider)
        self.sliderView.addSubview(self.radiusLabel)
        
        self.mapView.mapType = kGMSTypeHybrid
        
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
        self.circle.fillColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.25)
        self.circle.strokeColor = UIColor.whiteColor()
        self.circle.strokeWidth = 1
        self.circle.position = circleCenter
        self.circle.radius = CLLocationDistance(self.slider.value)
        self.circle.map = self.mapView
        
        self.layoutSubviews()
    }

}
