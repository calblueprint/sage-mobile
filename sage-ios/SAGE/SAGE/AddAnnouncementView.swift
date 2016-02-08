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
    var button = SGButton()
    
    //
    // MARK: - Initialization
    //
    init(frame: CGRect, edit: Bool) {
        super.init(frame: frame)
        self.keyboardControls.fields.append(self.title.textField)
        self.keyboardControls.fields.append(self.commentField.textView)
        if edit {
            self.addSubview(self.button)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        
        self.button.setTitle("Delete Announcement", forState: .Normal)
        self.button.setThemeColor(UIColor.redColor())
        self.button.titleLabel!.font = UIFont.normalFont
        self.button.sizeToFit()
        let width = CGRectGetWidth(self.button.frame)
        self.button.setWidth(width + 10)
        let buttonOffsetY = CGRectGetMaxY(self.commentField.frame)
        self.button.setY(buttonOffsetY + 20)
        self.button.centerHorizontally()
        
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
