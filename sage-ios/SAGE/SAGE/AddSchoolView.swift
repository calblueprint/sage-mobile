//
//  AddSchoolView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class AddSchoolView: FormView {
    
    var name =  FormFieldItem()
    var location = FormButtonItem()
    var director = FormButtonItem()
    var deleteSchoolButton = SGButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.keyboardControls.fields.append(self.name.textField)
        self.scrollView.addSubview(self.deleteSchoolButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
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

        self.self.deleteSchoolButton.hidden = true
        self.self.deleteSchoolButton.setTitle("Delete School", forState: .Normal)
        self.self.deleteSchoolButton.setThemeColor(UIColor.redColor())
        self.self.deleteSchoolButton.titleLabel!.font = UIFont.normalFont
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.director.fillWidth()
        
        self.location.setY(CGRectGetMaxY(self.director.frame))
        self.location.fillWidth()
        
        self.name.fillWidth()
        self.name.setY(CGRectGetMaxY(self.location.frame))

        self.deleteSchoolButton.sizeToFit()
        self.deleteSchoolButton.fillWidth()
        self.deleteSchoolButton.increaseHeight(40)
        self.deleteSchoolButton.setY(CGRectGetMaxY(self.name.frame))

        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetMaxY(self.deleteSchoolButton.frame))
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
