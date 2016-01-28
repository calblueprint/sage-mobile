//
//  FormView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 1/17/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit
import BSKeyboardControls


class FormView: UIView {
    
    var scrollView = UIScrollView()
    var keyboardControls = BSKeyboardControls()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.setupSubviews()
        self.keyboardControls.fields = []
        self.keyboardControls.barTintColor = UIColor.mainColor
        self.keyboardControls.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func setupSubviews() {
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.keyboardDismissMode = .OnDrag
        self.addSubview(self.scrollView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.fillWidth()
        self.scrollView.fillHeight()
    }

}

//
// MARK: - BSKeyboardControlsDelegate
//
extension FormView: BSKeyboardControlsDelegate {
    
    func keyboardControlsDonePressed(keyboardControls: BSKeyboardControls!) {
        keyboardControls.activeField.resignFirstResponder()
        self.scrollView.setContentOffset(CGPointZero, animated: true)
    }
}

//
// MARK: - UITextFieldDelegate
//
extension FormView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let offset = textField.superview!.frame.origin
        self.scrollView.setContentOffset(CGPointMake(0, offset.y), animated: true)
        self.keyboardControls.activeField = textField
    }
}


//
// MARK: - UITextViewDelegate
//
extension FormView: UITextViewDelegate {
    
    func textViewDidBeginEditing(textView: UITextView) {
        let offset = textView.superview!.frame.origin
        self.scrollView.setContentOffset(CGPointMake(0, offset.y), animated: true)
        self.keyboardControls.activeField = textView
    }
}
