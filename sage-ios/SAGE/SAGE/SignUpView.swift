//
//  SignUpView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/10/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import FontAwesomeKit

class SignUpView: UIView, UIScrollViewDelegate {
    
    var pageControl: UIPageControl = UIPageControl()
    var nameView = SignUpNameView()
    var emailPasswordView = SignUpEmailPasswordView()
    var schoolHoursView = SignUpSchoolHoursView()
    var photoView = SignUpPhotoView()
    var allViews = [SignUpFormView]()
    var xButton: UIButton = UIButton()
    var scrollView: UIScrollView = UIScrollView()
    var dismissKeyboard: Bool = true
    var currentErrorMessage: ErrorView?
    var tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
        
    override init(frame: CGRect) {
        let screenRect = UIScreen.mainScreen().bounds;
        let screenWidth = screenRect.size.width;
        let screenHeight = screenRect.size.height;
        let newFrame = CGRectMake(0, 0, screenWidth, screenHeight)
        super.init(frame: newFrame)
        self.setUpViews()
        self.scrollView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        self.setUpGestureRecognizer()

        self.scrollView.pagingEnabled = true
        self.scrollView.scrollsToTop = false
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * 4, CGRectGetHeight(self.frame))
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.pageControl.numberOfPages = 4
        self.pageControl.currentPage = 0
        self.pageControl.userInteractionEnabled = false
        
        let screenRect = UIScreen.mainScreen().bounds;
        let screenWidth = screenRect.size.width;
        
        self.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.nameView)
        self.scrollView.addSubview(self.emailPasswordView)
        self.scrollView.addSubview(self.schoolHoursView)
        self.scrollView.addSubview(self.photoView)
        
        self.addSubview(self.pageControl)
        self.addSubview(self.xButton)
        self.bringSubviewToFront(self.pageControl)
        
        self.allViews.append(self.nameView)
        self.allViews.append(self.emailPasswordView)
        self.allViews.append(self.schoolHoursView)
        self.allViews.append(self.photoView)
        
        self.nameView.setX(0)
        self.emailPasswordView.setX(screenWidth)
        self.schoolHoursView.setX(2 * screenWidth)
        self.photoView.setX(3 * screenWidth)
        
        self.nameView.backgroundColor = UIColor.lightRedColor
        self.emailPasswordView.backgroundColor = UIColor.lightOrangeColor
        self.schoolHoursView.backgroundColor = UIColor.lightYellowColor
        self.photoView.backgroundColor = UIColor.lightGreenColor
        
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
        
        let colors = [UIColor.lightRedColor, UIColor.lightOrangeColor, UIColor.lightYellowColor, UIColor.lightGreenColor, UIColor.lightGreenColor]
        
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
    // MARK: - UIScrollViewDelegate methods
    //
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        
        if scrollView.contentOffset.x < 0 {
            scrollView.setContentOffset(CGPointMake(0, 0), animated: false)
        } else if scrollView.contentOffset.x > 3 * self.frame.width {
            scrollView.setContentOffset(CGPointMake(3 * self.frame.width, 0), animated: false)
        } else if scrollView.contentOffset.x > screenWidth * 2 && !self.schoolHoursValid() {
            scrollView.setContentOffset(CGPointMake(2 * self.frame.width, 0), animated: false)
            self.showError("Please select a school and time commitment!")
        } else if scrollView.contentOffset.x > screenWidth && !emailPasswordValid() {
            scrollView.setContentOffset(CGPointMake(self.frame.width, 0), animated: false)
            self.showError("Please fill out your email and password!")
        } else if scrollView.contentOffset.x > 0 && !firstLastNameValid() {
            scrollView.setContentOffset(CGPointMake(0, 0), animated: false)
            self.showError("Please fill out your first and last name!")
        } else {
            if (self.dismissKeyboard) {
                self.endEditing(true)
                self.changeBackgroundColor(scrollView.contentOffset.x)
            } else {
                self.dismissKeyboard = true
            }
        }
    }
    
    //
    // MARK: - Validation and Errors
    //
    func schoolHoursValid() -> Bool {
        return self.schoolHoursView.chooseSchoolButton.titleLabel?.text! != "Choose School..." && self.schoolHoursView.chooseHoursButton.titleLabel?.text! != "Choose Hours..."
    }
    
    func emailPasswordValid() -> Bool {
        return self.emailPasswordView.emailInput.text! != "" && self.emailPasswordView.passwordInput.text! != "" && self.emailPasswordView.emailInput.text!.containsString("berkeley") && emailPasswordView.passwordInput.text!.characters.count > 7
    }
    
    func firstLastNameValid() -> Bool {
        return self.nameView.firstNameInput.text! != "" && self.nameView.lastNameInput.text! != ""
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    
    func showError(message: String) {
        if let current = self.currentErrorMessage {
            current.removeFromSuperview()
        }
        
        let errorView = ErrorView(height: 64.0, messageString: message)
        self.addSubview(errorView)
        self.bringSubviewToFront(errorView)
        errorView.setX(0)
        errorView.setY(-10)
        self.currentErrorMessage = errorView
        UIView.animateWithDuration(UIView.animationTime, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            errorView.setY(0)
            }) { (bool) -> Void in
                UIView.animateWithDuration(UIView.animationTime, delay: 3, options: .CurveLinear, animations: { () -> Void in
                    errorView.alpha = 0.0
                    errorView.setY(-64)
                    }, completion: nil)
        }
    }
    
}
