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
        
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetMaxY(self.commentField.frame))
    }
    
    //
    // MARK: - Private methods
    //
    private func setupSubviews() {
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.keyboardDismissMode = .OnDrag
        self.addSubview(self.scrollView)
        
        self.dateField.textField.delegate = self
        self.dateField.label.text = "Date"
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .Date
        self.dateField.textField.inputView = datePicker
        self.dateField.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.dateField)
        
        self.startTimeField.textField.delegate = self
        self.startTimeField.label.text = "Start Time"
        let startTimePicker = UIDatePicker()
        startTimePicker.datePickerMode = .Time
        self.startTimeField.textField.inputView = startTimePicker
        self.startTimeField.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.startTimeField)
        
        self.endTimeField.textField.delegate = self
        self.endTimeField.label.text = "End Time"
        let endTimePicker = UIDatePicker()
        endTimePicker.datePickerMode = .Time
        self.endTimeField.textField.inputView = endTimePicker
        self.endTimeField.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.endTimeField)
        
        self.commentField.textView.delegate = self
        self.commentField.label.text = "Comment"
        self.commentField.setHeight(FormTextItem.defaultHeight)
        self.scrollView.addSubview(self.commentField)
    }
}

//
// MARK: - UITextFieldDelegate
//
extension RequestHoursView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        let offset = textField.superview!.frame.origin
        self.scrollView.setContentOffset(CGPointMake(0, offset.y), animated: true)
        return true
    }
}

//
// MARK: - UITextViewDelegate
//
extension RequestHoursView: UITextViewDelegate {
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        let offset = textView.superview!.frame.origin
        self.scrollView.setContentOffset(CGPointMake(0, offset.y), animated: true)
        return true
    }
}
