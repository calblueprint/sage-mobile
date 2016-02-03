//
//  EditProfileController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 1/17/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

class EditProfileController: FormController {
    
    var user: User
    var editProfileView = EditProfileView()
    var choseNewPhoto = false
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.editProfileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Profile"
        self.editProfileView.setupWithUser(self.user)
        
        editProfileView.school.button.addTarget(self, action: "schoolButtonTapped", forControlEvents: .TouchUpInside)
        editProfileView.hours.button.addTarget(self, action: "hoursButtonTapped", forControlEvents: .TouchUpInside)
        editProfileView.photoButton.addTarget(self, action: "chooseNewPhoto", forControlEvents: .TouchUpInside)
    }
    
    @objc private func chooseNewPhoto() {
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
    
    @objc private func schoolButtonTapped() {
        let tableViewController = SelectSchoolEditProfileController()
        tableViewController.parentVCEditProfile = self
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        }
        self.navigationController?.pushViewController(tableViewController, animated: true)
    }
    
    @objc private func hoursButtonTapped() {
        let tableViewController = SelectHoursEditProfileController()
        tableViewController.parentVCEditProfile = self
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        }
        self.navigationController?.pushViewController(tableViewController, animated: true)
    }
    
    func didSelectSchool(school: School) {
        self.user.school = school
        self.editProfileView.displaySchoolName(school.name!)
        
    }
    
    func didSelectHours(hours: User.VolunteerLevel) {
        self.user.level = hours
        self.editProfileView.displayHours(self.user.level)
    }
    
    func completeForm() {
        if self.editProfileView.isValid() {
            self.user.firstName = self.editProfileView.getFirstName()
            self.user.lastName = self.editProfileView.getLastName()
            self.user.email = self.editProfileView.getEmail()
            self.finishButton?.startLoading()
            let password = editProfileView.getPassword()
            var photoData: String? = nil
            if self.choseNewPhoto {
                photoData = UIImage.encodedPhotoString(self.editProfileView.photoView.image!)
            }
            ProfileOperations.updateProfile(self.user, password: password, photoData: photoData, completion: { (updatedUser) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.editProfileKey, object: updatedUser)
                }) { (errorMessage) -> Void in
                    self.finishButton?.stopLoading()
                    let alertController = UIAlertController(
                        title: "Failure",
                        message: errorMessage as String,
                        preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
            }
        } else {
            let alertController = UIAlertController(
                title: "Error",
                message: "Please fill out required fields.",
                preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

}

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.choseNewPhoto = true
        let photoView = self.editProfileView.photoView
        photoView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
