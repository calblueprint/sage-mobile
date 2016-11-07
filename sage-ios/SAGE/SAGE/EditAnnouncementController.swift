//
//  EditAnnouncementController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 12/2/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class EditAnnouncementController: AddAnnouncementController {

    var announcement: Announcement?
    let editView = AddAnnouncementView()
    
    override func loadView() {
        super.loadView()
        self.view = self.editView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Announcement"
        (self.view as! AddAnnouncementView).deleteAnnouncementButton.addTarget(self, action: #selector(EditAnnouncementController.deleteAnnouncement(_:)), forControlEvents: .TouchUpInside)
    }
    
    func configureWithAnnouncement(announcement: Announcement) {
        self.announcement = announcement.copy() as? Announcement
        let editView = self.view as! AddAnnouncementView
        (self.view as! AddAnnouncementView).deleteAnnouncementButton.hidden = false
        if let school = self.announcement?.school {
            editView.displayChosenSchool(school)
        } else {
            editView.school.button.setTitle("Everyone", forState: .Normal)
        }
        editView.title.textField.text = self.announcement?.title
        editView.commentField.textView.text = self.announcement?.text
    }
    
    override func completeForm() {
        let editView = (self.view as! AddAnnouncementView)
        if editView.title.textField.text == nil || editView.title.textField.text == "" {
            self.showAlertControllerError("Please enter a title.")
        } else if editView.school.button.titleLabel!.text == nil || editView.school.button.titleLabel!.text == "" {
            self.showAlertControllerError("Please choose a school.")
        } else if editView.commentField.textView.text == nil || editView.commentField.textView.text == "" {
            self.showAlertControllerError("Please enter a comment.")
        } else {
            self.finishButton?.startLoading()
            editView.deleteAnnouncementButton.hidden = true
            if let school = self.school {
                self.announcement?.school = school
            }
            self.announcement?.title = editView.title.textField.text
            self.announcement?.text = editView.commentField.textView.text
            
            AdminOperations.editAnnouncement(self.announcement!, completion: { (editedAnnouncement) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.editAnnouncementKey, object: editedAnnouncement)
                }, failure: { (message) -> Void in
                    self.finishButton?.stopLoading()
                    editView.deleteAnnouncementButton.hidden = false
                    self.showAlertControllerError(message)
            })
        }
    }

    func deleteAnnouncement(sender: UIButton!) {
        let view = self.editView
        
        let deleteHandler: (UIAlertAction) -> Void = { _ in
            view.deleteAnnouncementButton.startLoading()
            self.finishButton?.startLoading()
            AnnouncementsOperations.deleteAnnouncement(self.announcement!, completion: { (announcement) -> Void in
                self.navigationController!.popToRootViewControllerAnimated(true)
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.deleteAnnouncementKey, object: self.announcement)
                }) { (errorMessage) -> Void in
                    view.deleteAnnouncementButton.stopLoading()
                    self.finishButton?.stopLoading()
                    let alertController = UIAlertController(
                        title: "Failure",
                        message: errorMessage as String,
                        preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        
        let alertController = UIAlertController(
            title: "Delete Announcement",
            message: "Are you sure you want to delete this announcement? This action cannot be undone.",
            preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Delete", style: .Default, handler: deleteHandler))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
