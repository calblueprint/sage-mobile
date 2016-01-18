//
//  StartSemesterController.swift
//  SAGE
//
//  Created by Andrew Millman on 1/17/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class StartSemesterController: UIViewController {
    
    var startSemesterView = StartSemesterView()
    
    private var finishButton: SGBarButtonItem?
    
    //
    // MARK: - ViewController Lifecycle
    //
    override func loadView() {
        self.view = self.startSemesterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Start Semester"
        self.finishButton = SGBarButtonItem(title: "Finish", style: .Done, target: self, action: "completeForm")
        self.navigationItem.rightBarButtonItem = self.finishButton
        self.startSemesterView.semesterTermItem.button.addTarget(self, action: "semesterButtonTapped", forControlEvents: .TouchUpInside)
    }
    
    @objc private func schoolButtonTapped() {
//        let tableViewController = SelectAnnouncementSchoolTableViewController()
//        tableViewController.parentVC = self
//        if let topItem = self.navigationController?.navigationBar.topItem {
//            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
//        }
//        self.navigationController?.pushViewController(tableViewController, animated: true)
    }
    
    func completeForm() {
        if self.startSemesterView.isValid() {
            //let finalAnnouncement = self.exportToAnnouncement()
            self.finishButton?.startLoading()
//            AdminOperations.createAnnouncement(finalAnnouncement, completion: { (announcement) -> Void in
//                self.navigationController?.popViewControllerAnimated(true)
//                NSNotificationCenter.defaultCenter().postNotificationName(NotificationConstants.addAnnouncementKey, object: announcement)
//                }) { (errorMessage) -> Void in
//                    self.finishButton?.stopLoading()
//                    let alertController = UIAlertController(
//                        title: "Failure",
//                        message: errorMessage as String,
//                        preferredStyle: .Alert)
//                    alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//                    self.presentViewController(alertController, animated: true, completion: nil)
//            }
        } else {
            let alertController = UIAlertController(
                title: "Error",
                message: "Please fill out required fields.",
                preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
//    private func exportToAnnouncement() -> Announcement {
//        let addView = self.view as! AddAnnouncementView
//        let announcement = Announcement(sender: LoginOperations.getUser(), title: addView.title.textField.text, text: addView.commentField.textView.text, timeCreated: NSDate(timeIntervalSinceNow: 0), school: self.school)
//        return announcement
//    }
    
//    func didSelectSchool(school: School) {
//        self.school = school
//        self.addAnnouncementView.displayChosenSchool(school)
//        
//    }
}