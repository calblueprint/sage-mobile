//
//  RequestHoursView.swift
//  SAGE
//
//  Created by Andrew on 10/27/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class RequestHoursView: FormView {
    
    var dateField =  FormFieldItem()
    var startTimeField = FormFieldItem()
    var endTimeField = FormFieldItem()
    var commentField = FormTextItem()
    
    private var startDate = NSDate()
    private var startTime = NSDate()
    private var endTime = NSDate()

    private var dateFormatter = NSDateFormatter()

    //
    // MARK: - Initialization
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.keyboardControls.fields.append(self.dateField.textField)
        self.keyboardControls.fields.append(self.startTimeField.textField)
        self.keyboardControls.fields.append(self.endTimeField.textField)
        self.keyboardControls.fields.append(self.commentField.textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
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
        self.startDate = sender.date
    }
    
    @objc private func startTimePicked(sender: UIDatePicker!) {
        self.dateFormatter.dateStyle = .NoStyle
        self.dateFormatter.timeStyle = .ShortStyle
        self.startTimeField.textField.text = self.dateFormatter.stringFromDate(sender.date)
        self.startTime = sender.date
    }
    
    @objc private func endTimePicked(sender: UIDatePicker!) {
        self.dateFormatter.dateStyle = .NoStyle
        self.dateFormatter.timeStyle = .ShortStyle
        self.endTimeField.textField.text = self.dateFormatter.stringFromDate(sender.date)
        self.endTime = sender.date
    }
    
    //
    // MARK: - Public methods
    //
    func setupWithCheckin(checkin: Checkin) {
        self.dateFormatter.dateStyle = .MediumStyle
        self.dateFormatter.timeStyle = .NoStyle
        self.dateField.textField.text = self.dateFormatter.stringFromDate(checkin.startTime!)
        self.startDate = checkin.startTime!
        
        self.dateFormatter.dateStyle = .NoStyle
        self.dateFormatter.timeStyle = .ShortStyle
        self.startTimeField.textField.text = self.dateFormatter.stringFromDate(checkin.startTime!)
        self.startTime = checkin.startTime!
        self.endTimeField.textField.text = self.dateFormatter.stringFromDate(checkin.endTime!)
        self.endTime = checkin.endTime!
        
        self.dateField.disable()
        self.startTimeField.disable()
        self.endTimeField.disable()
        self.keyboardControls.fields = [self.commentField.textView]
    }
    
    func exportToCheckinVerified(verified: Bool) -> Checkin {
        if !verified {
            self.adjustFinalDates()
        }
        let checkin: Checkin = Checkin(
            user: LoginOperations.getUser(),
            startTime: self.startTime,
            endTime: self.endTime,
            school: KeychainWrapper.defaultKeychainWrapper().objectForKey(KeychainConstants.kSchool) as? School,
            comment: self.commentField.textView.text,
            verified: verified
        )
        return checkin
    }
    
    func isValid() -> Bool {
        return
            self.dateField.textField.text?.characters.count > 0 &&
            self.startTimeField.textField.text?.characters.count > 0 &&
            self.endTimeField.textField.text?.characters.count > 0
    }
    

    override func setupSubviews() {
        super.setupSubviews()
        
        // Pre-fill date only
        self.dateFormatter.dateStyle = .MediumStyle
        self.dateFormatter.timeStyle = .NoStyle
        self.dateField.textField.text = self.dateFormatter.stringFromDate(self.startDate)

        self.dateField.label.text = "Date"
        self.dateField.textField.placeholder = "Enter a date"
        self.dateField.textField.delegate = self
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .Date
        datePicker.addTarget(self, action: #selector(RequestHoursView.datePicked(_:)), forControlEvents: .ValueChanged)
        self.dateField.textField.inputView = datePicker
        self.dateField.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.dateField)
        
        self.startTimeField.label.text = "Start Time"
        self.startTimeField.textField.placeholder = "Select start time"
        self.startTimeField.textField.delegate = self
        let startTimePicker = UIDatePicker()
        startTimePicker.datePickerMode = .Time
        startTimePicker.addTarget(self, action: #selector(RequestHoursView.startTimePicked(_:)), forControlEvents: .ValueChanged)
        self.startTimeField.textField.inputView = startTimePicker
        self.startTimeField.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.startTimeField)
        
        self.endTimeField.label.text = "End Time"
        self.endTimeField.textField.placeholder = "Select end time"
        self.endTimeField.textField.delegate = self
        let endTimePicker = UIDatePicker()
        endTimePicker.datePickerMode = .Time
        endTimePicker.addTarget(self, action: #selector(RequestHoursView.endTimePicked(_:)), forControlEvents: .ValueChanged)
        self.endTimeField.textField.inputView = endTimePicker
        self.endTimeField.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.endTimeField)
        
        self.commentField.label.text = "Comment"
        self.commentField.textView.delegate = self
        self.commentField.setHeight(FormTextItem.defaultHeight)
        self.scrollView.addSubview(self.commentField)
    }

    private func adjustFinalDates() {
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let components: NSCalendarUnit = [.Year, .Month, .Day , .Hour, .Minute, .TimeZone]

        let dateComponents = calendar!.components(components, fromDate: self.startDate)
        let startComponents = calendar!.components(components, fromDate: self.startTime)
        let endComponents = calendar!.components(components, fromDate: self.endTime)

        startComponents.year = dateComponents.year
        startComponents.month = dateComponents.month
        startComponents.day = dateComponents.day
        self.startTime = calendar!.dateFromComponents(startComponents)!

        endComponents.year = dateComponents.year
        endComponents.month = dateComponents.month
        endComponents.day = dateComponents.day
        self.endTime = calendar!.dateFromComponents(endComponents)!
    }
}
