//
//  AddSchoolView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import BSKeyboardControls

class AddSchoolView: UIView {
    
    var name =  FormFieldItem()
    var location = FormButtonItem()
    var director = FormButtonItem()
    
    private var scrollView = UIScrollView()
    private var keyboardControls = BSKeyboardControls()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.setupSubviews()
        self.keyboardControls.fields = [
            self.name.textField
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
        
        self.name.label.text = "School Name"
        self.name.textField.placeholder = "Enter the school's name"
        self.name.textField.delegate = self
        self.name.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.name)
        
        self.director.label.text = "Director"
        self.director.button.setTitle("Choose the director's name", forState: .Normal)
        self.director.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.director)
        
        self.location.label.text = "Address"
        self.location.button.setTitle("Choose the school's location", forState: .Normal)
        self.location.setHeight(FormFieldItem.defaultHeight)
        self.scrollView.addSubview(self.location)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.fillWidth()
        self.scrollView.fillHeight()
        
        self.director.fillWidth()
        
        self.location.setY(CGRectGetMaxY(self.director.frame))
        self.location.fillWidth()
        
        self.name.fillWidth()
        self.name.setY(CGRectGetMaxY(self.location.frame))
        
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetMaxY(self.name.frame))
    }
    
    func displayChosenDirector(director: User) {
        self.director.button.setTitle(director.fullName(), forState: .Normal)
        self.director.button.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    
    func displayChosenPlace(place: GMSPlace) {
        self.location.button.setTitle(place.formattedAddress, forState: .Normal)
        self.name.textField.text = place.name
        self.location.button.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    
    func displayAddressText(text: String?) {
        if let addressText = text {
            self.location.button.setTitle(addressText, forState: .Normal)
            self.location.button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
    }
    
    func displaySchoolName(name: String?) {
        self.name.textField.text = name
    }

}

//
// MARK: - BSKeyboardControlsDelegate
//
extension AddSchoolView: BSKeyboardControlsDelegate {
    
    func keyboardControlsDonePressed(keyboardControls: BSKeyboardControls!) {
        keyboardControls.activeField.resignFirstResponder()
        self.scrollView.setContentOffset(CGPointZero, animated: true)
    }
}

//
// MARK: - UITextFieldDelegate
//
extension AddSchoolView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let offset = textField.superview!.frame.origin
        self.scrollView.setContentOffset(CGPointMake(0, offset.y), animated: true)
        self.keyboardControls.activeField = textField
    }
}
