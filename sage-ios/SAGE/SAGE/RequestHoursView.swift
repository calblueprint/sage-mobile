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
    private var keyboardControls = BSKeyboardControls()
    private var scrollView = UIScrollView()
    private var dateFormatter = NSDateFormatter()

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
        
        self.dateField.fillWidth()
        
        self.startTimeField.setY(CGRectGetMaxY(self.dateField.frame))
        self.startTimeField.fillWidth()
        
        self.endTimeField.setY(CGRectGetMaxY(self.startTimeField.frame))
        self.endTimeField.fillWidth()

        self.commentField.setY(CGRectGetMaxY(self.endTimeField.frame))
        self.commentField.fillWidth()
        
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetMaxY(self.commentField.frame))
    }
    
    //
    // MARK: - Event handlers
    //
    @objc private func datePicked(sender: UIDatePicker!) {
        self.dateFormatter.dateStyle = .MediumStyle
        self.dateFormatter.timeStyle = .NoStyle
        self.dateField.textField.text = self.dateFormatter.stringFromDate(sender.date)
    }
    
    @objc private func startTimePicked(sender: UIDatePicker!) {
        self.dateFormatter.dateStyle = .NoStyle
        self.dateFormatter.timeStyle = .ShortStyle
        self.startTimeField.textField.text = self.dateFormatter.stringFromDate(sender.date)
    }
    
    @objc private func endTimePicked(sender: UIDatePicker!) {
        self.dateFormatter.dateStyle = .NoStyle
        self.dateFormatter.timeStyle = .ShortStyle
        self.endTimeField.textField.text = self.dateFormatter.stringFromDate(sender.date)
    }
    
    //
    // MARK: - Public methods
    //
    func setupWithCheckin(checkin: Checkin) {
        self.dateFormatter.dateStyle = .MediumStyle
        self.dateFormatter.timeStyle = .NoStyle
        self.dateField.textField.text = self.dateFormatter.stringFromDate(checkin.startTime!)
        
        self.dateFormatter.dateStyle = .NoStyle
        self.dateFormatter.timeStyle = .ShortStyle
        self.startTimeField.textField.text = self.dateFormatter.stringFromDate(checkin.startTime!)
        self.endTimeField.textField.text = self.dateFormatter.stringFromDate(checkin.endTime!)
        
        self.dateField.disable()
        self.startTimeField.disable()
        self.endTimeField.disable()
        self.keyboardControls.fields = [self.commentField.textView]
    }
    
    func exportToCheckin(verified: Bool) -> Checkin {
        let checkin: Checkin = Checkin(
            user: LoginOperations.getUser(),
            startTime: nil,
            endTime: nil,
            school: LoginOperations.getUser()?.school,
            comment: self.commentField.textView.text,
            verified: true
        )
        return checkin
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
        self.scrollView.setContentOffset(CGPointZero, animated: true)
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
