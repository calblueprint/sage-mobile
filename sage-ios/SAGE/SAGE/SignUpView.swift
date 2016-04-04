//
//  SignUpView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/10/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import FontAwesomeKit

class SignUpView: UIView {
    
    var pageControl: UIPageControl = UIPageControl()
    var nameView = SignUpNameView()
    var emailView = SignUpEmailView()
    var passwordView = SignUpPasswordView()
    var schoolHoursView = SignUpSchoolHoursView()
    var photoView = SignUpPhotoView()
    var allViews = [SignUpFormView]()
    var xButton: UIButton = UIButton()
    var scrollView: UIScrollView = UIScrollView()
    var dismissKeyboard: Bool = true
    var tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    var currentErrorMessage: ErrorView?
    var movedUp: Bool = false
    
    override init(frame: CGRect) {
        let screenRect = UIScreen.mainScreen().bounds;
        let screenWidth = screenRect.size.width;
        let screenHeight = screenRect.size.height;
        let newFrame = CGRectMake(0, 0, screenWidth, screenHeight)
        super.init(frame: newFrame)
        self.setUpViews()
        self.setUpKeyboardNotifications()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        self.setUpGestureRecognizer()

        self.scrollView.pagingEnabled = true
        self.scrollView.scrollsToTop = false
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * 5, CGRectGetHeight(self.frame))
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.pageControl.numberOfPages = 5
        self.pageControl.currentPage = 0
        self.pageControl.userInteractionEnabled = false
        
        let screenRect = UIScreen.mainScreen().bounds;
        let screenWidth = screenRect.size.width;
        
        self.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.nameView)
        self.scrollView.addSubview(self.emailView)
        self.scrollView.addSubview(self.passwordView)
        self.scrollView.addSubview(self.schoolHoursView)
        self.scrollView.addSubview(self.photoView)
        
        self.addSubview(self.pageControl)
        self.addSubview(self.xButton)
        self.bringSubviewToFront(self.pageControl)
        
        self.allViews.append(self.nameView)
        self.allViews.append(self.emailView)
        self.allViews.append(self.passwordView)
        self.allViews.append(self.schoolHoursView)
        self.allViews.append(self.photoView)
        
        self.nameView.setX(0)
        self.emailView.setX(screenWidth)
        self.passwordView.setX(2 * screenWidth)
        self.schoolHoursView.setX(3 * screenWidth)
        self.photoView.setX(4 * screenWidth)
        
        self.nameView.backgroundColor = UIColor.lightRedColor
        self.emailView.backgroundColor = UIColor.lightOrangeColor
        self.passwordView.backgroundColor = UIColor.lightYellowColor
        self.schoolHoursView.backgroundColor = UIColor.lightGreenColor
        self.photoView.backgroundColor = UIColor.lightBlueColor
        
        // any view setup goes here
    }
    
    override func layoutSubviews() {
        self.scrollView.setX(0)
        self.scrollView.setY(0)
        self.scrollView.fillWidth()
        self.scrollView.fillHeight()
        
        self.pageControl.sizeToFit()
        self.pageControl.centerHorizontally()
        self.pageControl.setY(225)
        
        self.xButton.setX(8)
        self.xButton.setY(8)
        self.xButton.setWidth(44)
        self.xButton.setHeight(66)
        let xButtonIcon = FAKIonIcons.closeRoundIconWithSize(22)
        xButtonIcon.setAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()])
        let xButtonImage = xButtonIcon.imageWithSize(CGSizeMake(22, 22))
        self.xButton.setImage(xButtonImage, forState: UIControlState.Normal)

    }
    
    //
    // MARK: - Methods for background color of scrollview
    //
    
    func calculateColor(firstColor: UIColor, secondColor: UIColor, offset: CGFloat) -> UIColor {
        let firstCIColor = CIColor(color: firstColor)
        let secondCIColor = CIColor(color: secondColor)
        let red = firstCIColor.red * (1 - offset) + secondCIColor.red * offset
        let green = firstCIColor.green * (1 - offset) + secondCIColor.green * offset
        let blue = firstCIColor.blue * (1 - offset) + secondCIColor.blue * offset
        let newColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        return newColor
    }
    
    func changeBackgroundColor(offset: CGFloat) {
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        
        let colorIndex = Int(offset / screenWidth)
        let colorOffset = (offset % screenWidth) / screenWidth
        self.pageControl.currentPage = colorIndex
        
        let colors = [UIColor.lightRedColor, UIColor.lightOrangeColor, UIColor.lightYellowColor, UIColor.lightGreenColor, UIColor.lightBlueColor, UIColor.lightBlueColor]
        
        for formView in self.allViews {
            formView.backgroundColor = self.calculateColor(colors[colorIndex], secondColor: colors[colorIndex + 1], offset: colorOffset)
        }
    }
    
    //
    // MARK: - Gesture recognizer methods
    //
    
    func screenTapped() {
        self.scrollView.endEditing(true)
        self.endEditing(true)
    }
    
    func setUpGestureRecognizer() {
        self.tapRecognizer.addTarget(self, action: "screenTapped")
        self.addGestureRecognizer(self.tapRecognizer)
        self.userInteractionEnabled = true
    }
    
    //
    // MARK: - Keyboard-related methods (to move up elements when the keyboard appears)
    //
    
    func setUpKeyboardNotifications() {
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let screenRect = UIScreen.mainScreen().bounds
        let screenHeight = screenRect.size.height
        
        if (!self.movedUp) && screenHeight == 568 {
            UIView.animateWithDuration(UIView.animationTime, animations: { () -> Void in
                    self.nameView.icon.alpha = 0.0
                    self.emailView.icon.alpha = 0.0
                    self.passwordView.icon.alpha = 0.0
                    self.pageControl.alpha = 0.0
                    self.nameView.firstNameInput.setY(self.nameView.firstNameInput.frame.origin.y - 65)
                    self.nameView.firstDivider.setY(self.nameView.firstDivider.frame.origin.y - 65)
                    self.nameView.lastNameInput.setY(self.nameView.lastNameInput.frame.origin.y - 65)
                    self.nameView.secondDivider.setY(self.nameView.secondDivider.frame.origin.y - 65)
                
                    self.emailView.emailInput.setY(self.emailView.emailInput.frame.origin.y - 65)
                    self.emailView.firstDivider.setY(self.emailView.firstDivider.frame.origin.y - 65)
                    self.emailView.emailConfirmationInput.setY(self.emailView.emailConfirmationInput.frame.origin.y - 65)
                    self.emailView.secondDivider.setY(self.emailView.secondDivider.frame.origin.y - 65)
                
                    self.passwordView.password.setY(self.passwordView.password.frame.origin.y - 65)
                    self.passwordView.firstDivider.setY(self.passwordView.firstDivider.frame.origin.y - 65)
                    self.passwordView.passwordConfirmation.setY(self.passwordView.passwordConfirmation.frame.origin.y - 65)
                    self.passwordView.secondDivider.setY(self.passwordView.secondDivider.frame.origin.y - 65)


                }, completion: nil)
            
            self.movedUp = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let screenRect = UIScreen.mainScreen().bounds
        let screenHeight = screenRect.size.height
        
        if (self.movedUp) && screenHeight == 568 {
            UIView.animateWithDuration(UIView.animationTime, animations: { () -> Void in
                    self.nameView.firstNameInput.setY(self.nameView.firstNameInput.frame.origin.y + 65)
                    self.nameView.firstDivider.setY(self.nameView.firstDivider.frame.origin.y + 65)
                    self.nameView.lastNameInput.setY(self.nameView.lastNameInput.frame.origin.y + 65)
                    self.nameView.secondDivider.setY(self.nameView.secondDivider.frame.origin.y + 65)
                
                    self.emailView.emailInput.setY(self.emailView.emailInput.frame.origin.y + 65)
                    self.emailView.firstDivider.setY(self.emailView.firstDivider.frame.origin.y + 65)
                    self.emailView.emailConfirmationInput.setY(self.emailView.emailConfirmationInput.frame.origin.y + 65)
                    self.emailView.secondDivider.setY(self.emailView.secondDivider.frame.origin.y + 65)
                
                    self.passwordView.password.setY(self.passwordView.password.frame.origin.y + 65)
                    self.passwordView.firstDivider.setY(self.passwordView.firstDivider.frame.origin.y + 65)
                    self.passwordView.passwordConfirmation.setY(self.passwordView.passwordConfirmation.frame.origin.y + 65)
                    self.passwordView.secondDivider.setY(self.passwordView.secondDivider.frame.origin.y + 65)
                
                    self.nameView.icon.alpha = 1.0
                    self.emailView.icon.alpha = 1.0
                    self.passwordView.icon.alpha = 1.0
                    self.pageControl.alpha = 1.0
                }, completion: nil)
            
            self.movedUp = false
        }
    }
}
