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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Announcement"
    }

    func configureWithAnnouncement(announcement: Announcement) {
        self.announcement = announcement
        let editView = self.view as! AddAnnouncementView
        editView.displayChosenSchool(self.announcement!.school!)
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
            if let school = self.school {
                self.announcement?.school = school
            }
            self.announcement?.title = editView.title.textField.text
            self.announcement?.text = editView.commentField.textView.text
            AdminOperations.editAnnouncement(self.announcement!, completion: { (editedAnnouncement) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.editAnnouncementKey, object: editedAnnouncement)
                }, failure: { (message) -> Void in
                    self.showAlertControllerError(message)
            })
        }
    }

}
