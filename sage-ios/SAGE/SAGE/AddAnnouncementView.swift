//
//  AddAnnouncementView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/22/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import BSKeyboardControls

class AddAnnouncementView: UIView {

    var title =  FormFieldItem()
    var school = FormButtonItem()
    var commentField = FormTextItem()
    
    var chosenSchool: School?
    
    private var keyboardControls = BSKeyboardControls()
    private var scrollView = UIScrollView()
    
    //
    // MARK: - Initialization
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.setupSubviews()
        self.keyboardControls.fields = [
            self.title.textField,
            self.commentField.textView
        ]
        self.keyboardControls.barTintColor = UIColor.mainColor
        self.keyboardControls.delegate = self
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    // MARK: - Private methods
    //
    private func setupSubviews() {
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.keyboardDismissMode = .OnDrag
        self.addSubview(self.scrollView)
        
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
        self.scrollView.fillWidth()
        self.scrollView.fillHeight()
        
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
    
    func exportToAnnouncement() -> Announcement {
        let announcement = Announcement(sender: LoginOperations.getUser(), title: self.title.textField.text, text: self.commentField.textView.text, timeCreated: NSDate(timeIntervalSinceNow: 0), school: self.chosenSchool)
        return announcement
    }
    
    func displayChosenSchool(school: School) {
        self.school.button.setTitle(school.name!, forState: .Normal)
        self.school.button.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }

}

//
// MARK: - BSKeyboardControlsDelegate
//
extension AddAnnouncementView: BSKeyboardControlsDelegate {
    
    func keyboardControlsDonePressed(keyboardControls: BSKeyboardControls!) {
        keyboardControls.activeField.resignFirstResponder()
        self.scrollView.setContentOffset(CGPointZero, animated: true)
    }
}

//
// MARK: - UITextFieldDelegate
//
extension AddAnnouncementView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let offset = textField.superview!.frame.origin
        self.scrollView.setContentOffset(CGPointMake(0, offset.y), animated: true)
        self.keyboardControls.activeField = textField
    }
}

//
// MARK: - UITextViewDelegate
//
extension AddAnnouncementView: UITextViewDelegate {
    
    func textViewDidBeginEditing(textView: UITextView) {
        let offset = textView.superview!.frame.origin
        self.scrollView.setContentOffset(CGPointMake(0, offset.y), animated: true)
        self.keyboardControls.activeField = textView
    }
}
