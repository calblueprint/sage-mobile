//
//  StartSemesterView.swift
//  SAGE
//
//  Created by Andrew Millman on 1/17/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import BSKeyboardControls

class StartSemesterView: UIView {
    
    var startDateItem =  FormFieldItem()
    var semesterTermItem = FormButtonItem()
    
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
        
        self.startDateItem.label.text = "Start Date"
        self.startDateItem.textField.placeholder = "Enter a date"
        self.startDateItem.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.startDateItem)
        
        self.semesterTermItem.label.text = "Recipients"
        self.semesterTermItem.button.setTitle("Select semester", forState: .Normal)
        self.semesterTermItem.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.semesterTermItem)

    }
    
    //
    // MARK: - Public Methods
    //
    func isValid() -> Bool {
        return
            self.startDateItem.textField.text?.characters.count > 0 &&
            self.semesterTermItem.button.titleLabel?.text?.characters.count > 0
    }
    
    func displayChosenSemester(school: School) {
        self.semesterTermItem.button.setTitle("Spring", forState: .Normal)
        self.semesterTermItem.button.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    
}
