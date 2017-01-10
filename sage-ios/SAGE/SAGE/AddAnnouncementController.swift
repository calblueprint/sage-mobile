//
//  AddAnnouncementController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/22/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class AddAnnouncementController: FormController {

    var addAnnouncementView = AddAnnouncementView()
    var school: School?

    //
    // MARK: - ViewController Lifecycle
    //
    override func loadView() {
        self.view = self.addAnnouncementView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create Announcement"
        self.addAnnouncementView.school.button.addTarget(self, action: #selector(AddAnnouncementController.schoolButtonTapped), forControlEvents: .TouchUpInside)
    }
    
    func prefillWithAnnouncement(announcement: Announcement) {
        (self.view as! AddAnnouncementView).deleteAnnouncementButton.hidden = false
        if let school = announcement.school {
            self.addAnnouncementView.displayChosenSchool(school)
        } else {
            self.addAnnouncementView.school.button.setTitle("Everyone", forState: .Normal)
        }
        self.addAnnouncementView.title.textField.text = announcement.title
        self.addAnnouncementView.commentField.textView.text = announcement.text
    }
    
    @objc private func schoolButtonTapped() {
        let tableViewController = SelectAnnouncementSchoolTableViewController()
        tableViewController.parentVC = self
        self.navigationController?.pushViewController(tableViewController, animated: true)
    }
    
    override func completeForm() {
        if self.addAnnouncementView.isValid() {
            let finalAnnouncement = self.exportToAnnouncement()
            self.finishButton?.startLoading()
            AdminOperations.createAnnouncement(finalAnnouncement, completion: { (announcement) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.addAnnouncementKey, object: announcement)
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
    
    private func exportToAnnouncement() -> Announcement {
        let addView = self.addAnnouncementView
        let announcement = Announcement(sender: SAGEState.currentUser(), title: addView.title.textField.text, text: addView.commentField.textView.text, timeCreated: NSDate(timeIntervalSinceNow: 0), school: self.school)
        return announcement
    }
    
    func didSelectSchool(school: School) {
        self.school = school
        self.addAnnouncementView.displayChosenSchool(school)

    }
}
