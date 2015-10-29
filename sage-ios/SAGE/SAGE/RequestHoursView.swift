//
//  RequestHoursView.swift
//  SAGE
//
//  Created by Andrew on 10/27/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation
import BSKeyboardControls

class RequestHoursView: UIView {
    
    var dateField =  FormFieldItem()
    var startTimeField = FormFieldItem()
    var endTimeField = FormFieldItem()
    var commentField = FormTextItem()
    var keyboardControls = BSKeyboardControls()
    private var scrollView = UIScrollView()

    //
    // MARK: - Initialization
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.setupSubviews()
        self.keyboardControls.fields = [
            self.dateField.textField,
            self.startTimeField.textField,
            self.endTimeField.textField,
            self.commentField.textView
        ]
        self.keyboardControls.barTintColor = UIColor.mainColor
        self.keyboardControls.delegate = self
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
    // MARK: - Event handlers
    //
    @objc private func datePicked(sender: UIDatePicker!) {
        
    }
    
    @objc private func startTimePicked(sender: UIDatePicker!) {
        
    }
    
    @objc private func endTimePicked(sender: UIDatePicker!) {
        
    }
    
    //
    // MARK: - Private methods
    //
    private func setupSubviews() {
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.keyboardDismissMode = .OnDrag
        self.addSubview(self.scrollView)
        
        self.dateField.label.text = "Date"
        self.dateField.textField.placeholder = "Enter a date"
        self.dateField.textField.delegate = self
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .Date
        datePicker.addTarget(self, action: "datePicked:", forControlEvents: .ValueChanged)
        self.dateField.textField.inputView = datePicker
        self.dateField.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.dateField)
        
        self.startTimeField.label.text = "Start Time"
        self.startTimeField.textField.placeholder = "Select start time"
        self.startTimeField.textField.delegate = self
        let startTimePicker = UIDatePicker()
        startTimePicker.datePickerMode = .Time
        startTimePicker.addTarget(self, action: "startTimePicked:", forControlEvents: .ValueChanged)
        self.startTimeField.textField.inputView = startTimePicker
        self.startTimeField.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.startTimeField)
        
        self.endTimeField.label.text = "End Time"
        self.endTimeField.textField.placeholder = "Select end time"
        self.endTimeField.textField.delegate = self
        let endTimePicker = UIDatePicker()
        endTimePicker.datePickerMode = .Time
        endTimePicker.addTarget(self, action: "endTimePicked:", forControlEvents: .ValueChanged)
        self.endTimeField.textField.inputView = endTimePicker
        self.endTimeField.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.endTimeField)
        
        self.commentField.label.text = "Comment"
        self.commentField.textView.delegate = self
        self.commentField.setHeight(FormTextItem.defaultHeight)
        self.scrollView.addSubview(self.commentField)
    }
}

//
// MARK: - BSKeyboardControlsDelegate
//
extension RequestHoursView: BSKeyboardControlsDelegate {
    
    func keyboardControlsDonePressed(keyboardControls: BSKeyboardControls!) {
        keyboardControls.activeField.resignFirstResponder()
    }
}

//
// MARK: - UITextFieldDelegate
//
extension RequestHoursView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let offset = textField.superview!.frame.origin
        self.scrollView.setContentOffset(CGPointMake(0, offset.y), animated: true)
        self.keyboardControls.activeField = textField
    }
}

//
// MARK: - UITextViewDelegate
//
extension RequestHoursView: UITextViewDelegate {
    
    func textViewDidBeginEditing(textView: UITextView) {
        let offset = textView.superview!.frame.origin
        self.scrollView.setContentOffset(CGPointMake(0, offset.y), animated: true)
        self.keyboardControls.activeField = textView
    }
}
