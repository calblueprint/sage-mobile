//
//  SignUpController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/9/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import FontAwesomeKit

class SignUpController: UIViewController  {
    
    // using nsmutable dictionaries so we can pass them by reference instead of by value
    var schoolDict = NSMutableDictionary()
    var volunteerDict = NSMutableDictionary()
    
    //
    // MARK: - Overridden UIViewController methods
    //
    override func loadView() {
        self.view = SignUpView()
        self.setUpTargetActionPairs()
        self.setDelegates()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.alpha = 0.0
        UIView.animateWithDuration(UIView.animationTime/2, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            self.view.alpha = 1.0
            }, completion: nil)
    }
    
    func setDelegates() {
        let signUpView = (self.view as! SignUpView)
        let nameView = signUpView.nameView
        let emailPasswordView = signUpView.emailPasswordView
        nameView.firstNameInput.delegate = self
        nameView.lastNameInput.delegate = self
        emailPasswordView.emailInput.delegate = self
        emailPasswordView.passwordInput.delegate = self
        
    }
    
    func setUpTargetActionPairs(){
        let signUpView = (self.view as! SignUpView)
        let schoolHoursView = signUpView.schoolHoursView
        let photoView = signUpView.photoView
        
        signUpView.xButton.addTarget(self, action: "xButtonPressed", forControlEvents: .TouchUpInside)
        schoolHoursView.chooseSchoolButton.addTarget(self, action: "presentSchoolModal", forControlEvents: .TouchUpInside)
        schoolHoursView.chooseHoursButton.addTarget(self, action: "presentHoursModal", forControlEvents: .TouchUpInside)
        photoView.photoButton.addTarget(self, action: "choosePhoto", forControlEvents: .TouchUpInside)
        photoView.takePhotoButton.addTarget(self, action: "choosePhoto", forControlEvents: .TouchUpInside)
        photoView.skipAndFinishLink.addTarget(self, action: "createAccountAndProceedToAppWithoutPicture", forControlEvents: .TouchUpInside)
        photoView.finishButton.addTarget(self, action: "createAccountAndProceedToAppWithPicture", forControlEvents: .TouchUpInside)
    }
    
    //
    // MARK: - Methods to take and process photo
    //
    func createAccountAndProceedToAppWithoutPicture() {
        self.showLoadingView()
        let completion = { (success: Bool) -> Void in
            // switching back to main thread to ensure that UIKIT methods get called on the main thread
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if (success) {
                    let unverifiedController = UnverifiedViewController()
                    self.presentViewController(unverifiedController, animated: true, completion: nil)
                } else {
                    self.showFailureModal()
                }
            })
        }
        self.makeAccount(completion)
    }
    
    func createAccountAndProceedToAppWithPicture() {
        self.showLoadingView()
        let completion = { (success: Bool) -> Void in
            // switching back to main thread to ensure that UIKIT methods get called on the main thread
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if (success) {
                    let unverifiedController = UnverifiedViewController()
                    let signUpView = (self.view as! SignUpView)
                    let photoView = signUpView.photoView
                    unverifiedController.setImage(photoView.photo.image!)
                    self.presentViewController(unverifiedController, animated: true, completion: nil)
                } else {
                    self.showFailureModal()
                }
            })
        }
        self.makeAccount(completion)
    }
    
    func showLoadingView() {
        let frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let image = UIImage.init(named: UIConstants.blurredBerkeleyBackground)
        let imageView = UIImageView.init(frame: frame)
        imageView.image = image
        self.view.addSubview(imageView)
        
        let activityIndicatorFrame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        let activityIndicator = UIActivityIndicatorView(frame: activityIndicatorFrame)
        activityIndicator.color = UIColor.whiteColor()
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
    }
    
    func showFailureModal() {
        let alertController = UIAlertController(title: "Sorry!", message: "We're sorry! Something went wrong. Try again?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func makeAccount(completion: ((Bool) -> Void)) {
        let signUpView = (self.view as! SignUpView)
        let nameView = signUpView.nameView
        let emailPasswordView = signUpView.emailPasswordView
        let schoolHoursView = signUpView.schoolHoursView
        let photoView = signUpView.photoView
        
        let firstName = nameView.firstNameInput.text!
        let lastName = nameView.lastNameInput.text!
        let email = emailPasswordView.emailInput.text!
        let password = emailPasswordView.passwordInput.text!
        
        let school = self.schoolDict[schoolHoursView.chooseSchoolButton.titleLabel!.text!] as! Int
        
        let hoursString = schoolHoursView.chooseHoursButton.titleLabel!.text!
        let hours = self.volunteerDict[hoursString] as! Int
        let verified = false
        let role = 0
        
        var photoData: String
        if let image = photoView.photo.image {
            photoData = UIImage.encodedPhotoString(image)
        } else {
            let personIcon = FAKIonIcons.personIconWithSize(200)
            personIcon.setAttributes([NSForegroundColorAttributeName: UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)])
            let personImage = personIcon.imageWithSize(CGSizeMake(200, 200))
            photoData = UIImage.encodedPhotoString(personImage)
        }
        
        LoginHelper.storeUserDataInKeychain(firstName, lastName: lastName, email: email, password: password, school: school, hours: hours, verified: verified)
        
        LoginHelper.createUser(firstName, lastName: lastName, email: email, password: password, school: school, hours: hours, role: role, photoData: photoData, completion: completion)
    }
    
    func choosePhoto() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let imagePickerController: UIImagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .Default, handler: { (alertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                imagePickerController.sourceType = .Camera
                self.presentViewController(imagePickerController, animated: true, completion: nil)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose From Library", style: .Default, handler: { (alertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                imagePickerController.sourceType = .PhotoLibrary
                self.presentViewController(imagePickerController, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alertAction) -> Void in
            actionSheet.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    //
    // MARK: - Methods to present a table view to select school and hours
    //
    
    func presentSchoolModal() {
        let tableViewController = SignUpTableViewController(type: SignUpTableViewController.ContentType.School, schoolIDDict: self.schoolDict, volunteerlevelDict: self.volunteerDict)
        let navigationController = UINavigationController(rootViewController: tableViewController)
        tableViewController.parentVC = self
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func presentHoursModal() {
        let tableViewController = SignUpTableViewController(type: SignUpTableViewController.ContentType.Hours, schoolIDDict: self.schoolDict, volunteerlevelDict: self.volunteerDict)
        let navigationController = UINavigationController(rootViewController: tableViewController)
        tableViewController.parentVC = self
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    
    //
    // MARK: - Other actions
    //
    func xButtonPressed() {
        self.dismissViewControllerAnimated(false, completion: nil)
        UIView.animateWithDuration(UIView.animationTime) { () -> Void in
            self.view.alpha = 0.0
        }
    }
}

extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let signUpView = (self.view as! SignUpView)
        let photoView = signUpView.photoView
        
        photoView.photo.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        photoView.finishButton.hidden = false
        photoView.skipAndFinishLink.hidden = true
        photoView.photoLabel.text = "Change photo"
        photoView.headerLabel.text = "All done!"
        photoView.subHeaderLabel.text = "Looking great!"
        photoView.headerLabel.sizeToFit()
        photoView.subHeaderLabel.sizeToFit()
        photoView.headerLabel.centerHorizontally()
        photoView.subHeaderLabel.centerHorizontally()
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let signUpView = (self.view as! SignUpView)
        let nameView = signUpView.nameView
        let emailPasswordView = signUpView.emailPasswordView
        let firstName = nameView.firstNameInput
        let lastName = nameView.lastNameInput
        let email = emailPasswordView.emailInput
        let password = emailPasswordView.passwordInput
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        
        if textField == firstName {
            lastName.becomeFirstResponder()
        } else if textField == lastName {
            if firstName.text! != "" && lastName.text! != "" {
                UIView.animateWithDuration(UIView.animationTime, animations: { () -> Void in
                    signUpView.dismissKeyboard = false
                    let newPoint = CGPointMake(signUpView.scrollView.contentOffset.x + screenWidth, signUpView.scrollView.contentOffset.y)
                    signUpView.scrollView.contentOffset = newPoint
                    signUpView.changeBackgroundColor(newPoint.x)
                    }, completion: { (value) -> Void in
                        email.becomeFirstResponder()
                })
            } else {
                signUpView.showError("Please fill out your first and last name!")
            }
        } else if textField == email {
            password.becomeFirstResponder()
        } else {
            if password.text! != "" && signUpView.isValidEmail(email.text!) {
            
                UIView.animateWithDuration(UIView.animationTime, animations: { () -> Void in
                    let newPoint = CGPointMake(signUpView.scrollView.contentOffset.x + screenWidth, signUpView.scrollView.contentOffset.y)
                    signUpView.scrollView.contentOffset = newPoint
                    signUpView.changeBackgroundColor(newPoint.x)
                }, completion: nil)
            } else {
                signUpView.showError("Please fill out your email and password!")
            }
        }
        return true
    }
}
