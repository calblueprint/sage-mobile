//
//  StartSemesterView.swift
//  SAGE
//
//  Created by Andrew Millman on 1/17/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

class StartSemesterView: UIView {
    
    var startDateItem =  FormFieldItem()
    var semesterTermItem = FormFieldItem()

    private var scrollView = UIScrollView()
    
    private var startDate = NSDate()
    private var dateFormatter = NSDateFormatter()
    
    private var termList: [Term] = [.Fall, .Spring]
    private var selectedTerm: Term = .Fall
    
    //
    // MARK: - Initialization
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.scrollView.fillWidth()
        self.scrollView.fillHeight()
        
        
        self.startDateItem.fillWidth()
        
        self.semesterTermItem.setY(CGRectGetMaxY(self.startDateItem.frame))
        self.semesterTermItem.fillWidth()
        
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetMaxY(self.semesterTermItem.frame))
    }
    
    private func setupSubviews() {
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.keyboardDismissMode = .OnDrag
        self.addSubview(self.scrollView)
        
        // Pre-fill date
        self.dateFormatter.dateStyle = .MediumStyle
        self.dateFormatter.timeStyle = .NoStyle
        self.startDateItem.textField.text = self.dateFormatter.stringFromDate(self.startDate)
        
        self.startDateItem.label.text = "Start Date"
        self.startDateItem.textField.placeholder = "Enter a date"
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .Date
        datePicker.addTarget(self, action: "datePicked:", forControlEvents: .ValueChanged)
        self.startDateItem.textField.inputView = datePicker
        self.startDateItem.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.startDateItem)
        
        // Pre-fill term
        self.semesterTermItem.textField.text = Semester.stringFromTerm(self.termList[0])
        
        self.semesterTermItem.label.text = "Term"
        self.semesterTermItem.textField.placeholder = "Select a term"
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        self.semesterTermItem.textField.inputView = pickerView
        self.semesterTermItem.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.semesterTermItem)

    }
    
    //
    // MARK: - Event handlers
    //
    @objc private func datePicked(sender: UIDatePicker!) {
        self.startDateItem.textField.text = self.dateFormatter.stringFromDate(sender.date)
        self.startDate = sender.date
    }
    
    //
    // MARK: - Public Methods
    //
    func isValid() -> Bool {
        return
            self.startDateItem.textField.text?.characters.count > 0 &&
            self.startDateItem.textField.text?.characters.count > 0
    }
    
    func exportToSemester() -> Semester {
        return Semester(id: -1, startDate: self.startDate, term: self.selectedTerm)
    }
}

//
// MARK: - UIPickerViewDelegate
//
extension StartSemesterView: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Semester.stringFromTerm(self.termList[row])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.semesterTermItem.textField.text = Semester.stringFromTerm(self.termList[row])
        self.selectedTerm = self.termList[row]
    }
}

//
// MARK: - UIPickerViewDataSource
//
extension StartSemesterView: UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
}