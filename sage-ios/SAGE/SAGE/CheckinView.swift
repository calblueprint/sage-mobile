//
//  CheckinView.swift
//  SAGE
//
//  Created by Andrew on 10/3/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class CheckinView: UIView {

    var mapView: GMSMapView = GMSMapView()
    var startButton: UIButton = UIButton()
    var endButton: UIButton = UIButton()

    //
    // MARK: - Initialization
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.addSubview(self.mapView)

        //self.startButton.backgroundColor = UIColor.l
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.mapView.fillWidth()
        self.mapView.fillHeight()
    }
}
