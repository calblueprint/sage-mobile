//
//  AddAnnouncementView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/22/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class AddAnnouncementView: FormView {

    var title =  FormFieldItem()
    var school = FormButtonItem()
    var commentField = FormTextItem()
    
    //
    // MARK: - Initialization
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.keyboardControls.fields.append(self.title.textField)
        self.keyboardControls.fields.append(self.commentField.textView)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        self.title.label.text = "Title"
        self.title.textField.placeholder = "Enter a title"
        self.title.textField.delegate = self
        self.title.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.title)
        
        self.school.label.text = "Recipients"
        self.school.button.setTitle("Select recipients (optional)", forState: .Normal)
        self.school.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.school)
        
        self.commentField.label.text = "Comment"
        self.commentField.textView.delegate = self
        self.commentField.setHeight(FormTextItem.defaultHeight)
        self.scrollView.addSubview(self.commentField)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.title.fillWidth()
        
        self.school.setY(CGRectGetMaxY(self.title.frame))
        self.school.fillWidth()
        
        self.commentField.setY(CGRectGetMaxY(self.school.frame))
        self.commentField.fillWidth()
        
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetMaxY(self.commentField.frame))
    }
    
    func isValid() -> Bool {
        return
            self.title.textField.text?.characters.count > 0 &&
            self.school.button.titleLabel?.text?.characters.count > 0 &&
            self.commentField.textView.text?.characters.count > 0
    }
    
    func displayChosenSchool(school: School) {
        self.school.button.setTitle(school.name!, forState: .Normal)
        self.school.button.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }

}
