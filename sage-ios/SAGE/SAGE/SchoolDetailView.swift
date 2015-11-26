//
//  SchoolDetailView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/26/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class SchoolDetailView: UIView {

    var mapView: GMSMapView = GMSMapView()
    var schoolName = UILabel()
    var directorName = UILabel()
    var studentsList = UILabel()
    
    
    //
    // MARK: - Initialization
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.setUpViews()
        
    }
    
    func setUpViews() {
        self.addSubview(self.mapView)
        self.addSubview(self.schoolName)
        self.addSubview(self.directorName)
        self.addSubview(self.studentsList)
        self.schoolName.font = UIFont.titleFont
        self.directorName.font = UIFont.getDefaultFont(15)
        self.studentsList.font = UIFont.metaFont
        self.studentsList.textColor = UIColor.secondaryTextColor
        self.studentsList.lineBreakMode = .ByTruncatingTail
        self.studentsList.numberOfLines = 20
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
        
        self.schoolName.sizeToFit()
        self.schoolName.setY(CGRectGetMaxY(self.mapView.frame) + UIConstants.verticalMargin)
        self.schoolName.setX(UIConstants.sideMargin)
        
        self.directorName.sizeToFit()
        self.directorName.setY(CGRectGetMaxY(self.schoolName.frame))
        self.directorName.setX(UIConstants.sideMargin)

        self.studentsList.setY(CGRectGetMaxY(self.directorName.frame))
        self.studentsList.setX(UIConstants.sideMargin)
        self.studentsList.fillWidthWithMargin(UIConstants.sideMargin)
        let width = CGRectGetWidth(self.studentsList.frame)
        
        self.studentsList.setSize(self.studentsList.sizeThatFits(CGSizeMake(width, CGFloat.max)))
    }
}
