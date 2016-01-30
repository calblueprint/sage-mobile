//
//  SchoolDetailHeaderView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/26/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class SchoolDetailHeaderView: UIView {
    
    var mapView: GMSMapView = GMSMapView()
    
    //
    // MARK: - Initialization
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.mapView.settings.scrollGestures = false
        self.mapView.settings.zoomGestures = false
        self.addSubview(self.mapView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.mapView.fillWidth()
        
        let screenRect = UIScreen.mainScreen().bounds
        let screenHeight = screenRect.size.height
        self.mapView.setHeight(screenHeight * 0.4)
        self.setHeight(CGRectGetMaxY(self.mapView.frame))
        
    }
}
