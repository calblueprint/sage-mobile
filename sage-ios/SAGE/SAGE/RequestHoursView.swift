//
//  RequestHoursView.swift
//  SAGE
//
//  Created by Andrew on 10/27/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class RequestHoursView: UIView {
    
    var dateField =  FormFieldItem()
    var startTimeField = FormFieldItem()
    var endTimeField = FormFieldItem()
    var commentField = FormTextItem()
    private var scrollView = UIScrollView()

    //
    // MARK: - Initialization
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        self.scrollView.fillWidth()
        self.scrollView.fillHeight()
        
        self.dateField.setX(UIConstants.sideMargin)
        self.dateField.fillWidthWithMargin(UIConstants.sideMargin)
        
        self.startTimeField.setX(UIConstants.sideMargin)
        self.startTimeField.setY(CGRectGetMaxY(self.dateField.frame))
        self.startTimeField.fillWidthWithMargin(UIConstants.sideMargin)
        
        self.endTimeField.setX(UIConstants.sideMargin)
        self.endTimeField.setY(CGRectGetMaxY(self.startTimeField.frame))
        self.endTimeField.fillWidthWithMargin(UIConstants.sideMargin)

        self.commentField.setX(UIConstants.sideMargin)
        self.commentField.setY(CGRectGetMaxY(self.endTimeField.frame))
        self.commentField.fillWidthWithMargin(UIConstants.sideMargin)
    }
    
    //
    // MARK: - Private methods
    //
    private func setupSubviews() {
        self.addSubview(self.scrollView)
        
        self.dateField.label.text = "Date"
        self.dateField.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.dateField)
        
        self.startTimeField.label.text = "Start Time"
        self.startTimeField.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.startTimeField)
        
        self.endTimeField.label.text = "End Time"
        self.endTimeField.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.endTimeField)
        
        self.commentField.label.text = "Comment"
        self.commentField.setHeight(FormTextItem.defaultHeight)
        self.scrollView.addSubview(self.commentField)
    }
}
