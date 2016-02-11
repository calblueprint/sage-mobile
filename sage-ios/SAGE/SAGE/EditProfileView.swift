//
//  EditProfileView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 1/17/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

class EditProfileView: FormView {

    var photoButton = UIButton()
    var photoView = UIImageView()
    
    var firstName = FormFieldItem()
    var lastName = FormFieldItem()
    var email = FormFieldItem()
    var school = FormButtonItem()
    var hours = FormButtonItem()
    let newPassword = FormFieldItem()
    let newPasswordConfirmation = FormFieldItem()
    let password = FormFieldItem()
    let changePasswordLabel = UILabel()
    let profileImageSize = CGFloat(90)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.keyboardControls.fields.append(self.firstName.textField)
        self.keyboardControls.fields.append(self.lastName.textField)
        self.keyboardControls.fields.append(self.email.textField)
        self.keyboardControls.fields.append(self.newPassword.textField)
        self.keyboardControls.fields.append(self.newPasswordConfirmation.textField)
        self.keyboardControls.fields.append(self.password.textField)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        self.photoButton.layer.cornerRadius = self.profileImageSize/2
        self.photoButton.clipsToBounds = true
        self.scrollView.addSubview(self.photoButton)
        
        self.photoView.layer.cornerRadius = self.profileImageSize/2
        self.photoView.clipsToBounds = true
        self.scrollView.addSubview(self.photoView)
        
        self.firstName.label.text = "First Name"
        self.firstName.textField.delegate = self
        self.firstName.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.firstName)
        
        self.lastName.label.text = "Last Name"
        self.lastName.textField.delegate = self
        self.lastName.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.lastName)
        
        self.email.label.text = "Email"
        self.email.textField.delegate = self
        self.email.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.email)
        
        self.school.label.text = "School"
        self.school.button.setTitle("Choose the school", forState: .Normal)
        self.school.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.school)
        
        self.hours.label.text = "Hours"
        self.hours.button.setTitle("Choose your hours", forState: .Normal)
        self.hours.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.hours)
        
        self.changePasswordLabel.text = "Change Password"
        self.changePasswordLabel.font = UIFont.semiboldFont
        self.changePasswordLabel.textColor = UIColor.blackColor()
        self.scrollView.addSubview(self.changePasswordLabel)
        
        self.newPassword.label.text = "Password"
        self.newPassword.textField.delegate = self
        self.newPassword.textField.placeholder = "Change password (optional)"
        self.newPassword.setHeight(FormFieldItem.defaultHeight)
        self.newPassword.textField.secureTextEntry = true
        self.scrollView.addSubview(self.newPassword)
        
        self.newPasswordConfirmation.label.text = "Confirm"
        self.newPasswordConfirmation.textField.delegate = self
        self.newPasswordConfirmation.textField.placeholder = "Confirm new password (optional)"
        self.newPasswordConfirmation.setHeight(FormFieldItem.defaultHeight)
        self.newPasswordConfirmation.textField.secureTextEntry = true
        self.scrollView.addSubview(self.newPasswordConfirmation)
        
        self.password.label.text = "Password"
        self.password.textField.delegate = self
        self.password.textField.placeholder = "Enter your password."
        self.password.setHeight(FormFieldItem.defaultHeight)
        self.password.textField.secureTextEntry = true
        self.scrollView.addSubview(self.password)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.photoButton.setHeight(self.profileImageSize)
        self.photoButton.setWidth(self.profileImageSize)
        self.photoButton.setX(UIConstants.sideMargin)
        self.photoButton.setY(UIConstants.verticalMargin)

        self.photoView.setHeight(self.profileImageSize)
        self.photoView.setWidth(self.profileImageSize)
        self.photoView.setX(UIConstants.sideMargin)
        self.photoView.setY(UIConstants.verticalMargin)

        
        let nameWidth = self.frame.width - 2 * UIConstants.sideMargin - UIConstants.textMargin - self.photoView.frame.width
        let nameX = UIConstants.textMargin + UIConstants.verticalMargin + self.photoView.frame.width
        
        self.firstName.setWidth(nameWidth)
        self.firstName.setX(nameX)
        self.firstName.setY(UIConstants.verticalMargin)
        
        self.lastName.setWidth(nameWidth)
        self.lastName.setY(CGRectGetMaxY(self.firstName.frame))
        self.lastName.setX(nameX)
        
        self.email.fillWidth()
        self.email.setY(CGRectGetMaxY(self.lastName.frame))
        
        self.school.fillWidth()
        self.school.setY(CGRectGetMaxY(self.email.frame))
        
        self.hours.fillWidth()
        self.hours.setY(CGRectGetMaxY(self.school.frame))
        
        self.password.fillWidth()
        self.password.setY(CGRectGetMaxY(self.hours.frame))
        
        self.changePasswordLabel.sizeToFit()
        self.changePasswordLabel.setY(CGRectGetMaxY(self.password.frame) + 4*UIConstants.verticalMargin)
        self.changePasswordLabel.setX(UIConstants.sideMargin)
        
        self.newPassword.fillWidth()
        self.newPassword.setY(CGRectGetMaxY(self.changePasswordLabel.frame) + UIConstants.verticalMargin)
        
        self.newPasswordConfirmation.fillWidth()
        self.newPasswordConfirmation.setY(CGRectGetMaxY(self.newPassword.frame))

        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetMaxY(self.password.frame))
    }
    
    //
    // MARK: - Display Methods
    //
    func displayFirstName(firstName: String) {
        self.firstName.textField.text = firstName
    }
    
    func displayLastName(lastName: String) {
        self.lastName.textField.text = lastName
    }

    func displayEmail(email: String) {
        self.email.textField.text = email
    }
    
    func displaySchoolName(schoolName: String?) {
        self.school.button.setTitle(schoolName, forState: .Normal)
        self.school.button.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    
    func displayHours(hours: User.VolunteerLevel) {
        if hours == .ZeroUnit {
            self.hours.button.setTitle("0 Units", forState: .Normal)
            self.hours.button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        } else if hours == .OneUnit {
            self.hours.button.setTitle("1 Unit", forState: .Normal)
            self.hours.button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        } else if hours == .TwoUnit {
            self.hours.button.setTitle("2 Units", forState: .Normal)
            self.hours.button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
    }
    
    func setProfileImage(user: User) {
        self.photoView.setImageWithUser(user)
    }
    
    func isValid() -> Bool {
        if self.firstName.textField.text == "" {
            return false
        } else if self.lastName.textField.text == "" {
            return false
        } else if self.email.textField.text == "" {
            return false
        } else if self.password.textField.text == "" {
            return false
        } else if self.newPassword.textField.text == "" && self.newPasswordConfirmation.textField.text != ""{
            return false
        } else if self.newPasswordConfirmation.textField.text == "" && self.newPassword.textField.text != "" {
            return false
        } else {
            return true
        }
    }
    
    func setupWithUser(user: User) {
        self.displayFirstName(user.firstName!)
        self.displayLastName(user.lastName!)
        self.displayEmail(user.email!)
        self.displaySchoolName(user.school?.name)
        self.displayHours(user.level)
        self.setProfileImage(user)
    }
    
    func getFirstName() -> String {
        return self.firstName.textField.text!
    }
    
    func getLastName() -> String {
        return self.lastName.textField.text!
    }
    
    func getEmail() -> String {
        return self.email.textField.text!
    }
    
    func getPassword() -> String {
        return self.password.textField.text!
    }
    
    func getNewPassword() -> String? {
        return self.newPassword.textField.text
    }
    
    func getPasswordConfirmation() -> String? {
        return self.newPasswordConfirmation.textField.text
    }

}
