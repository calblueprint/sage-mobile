//
//  AddAnnouncementController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/22/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class AddAnnouncementController: UIViewController {

    var addAnnouncementView = AddAnnouncementView()
    var school: School?

    private var finishButton: SGBarButtonItem?

    //
    // MARK: - ViewController Lifecycle
    //
    override func loadView() {
        self.view = self.addAnnouncementView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create Announcement"
        self.finishButton = SGBarButtonItem(title: "Finish", style: .Done, target: self, action: "completeForm")
        self.navigationItem.rightBarButtonItem = self.finishButton
        self.addAnnouncementView.school.button.addTarget(self, action: "schoolButtonTapped", forControlEvents: .TouchUpInside)
    }
    
    @objc private func schoolButtonTapped() {
        let tableViewController = SelectAnnouncementSchoolTableViewController()
        tableViewController.parentVC = self
        if let topItem = self.navigationController!.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        }
        self.navigationController!.pushViewController(tableViewController, animated: true)
    }
    
    @objc private func completeForm() {
        if self.addAnnouncementView.isValid() {
            self.finishButton?.startLoading()
            let finalAnnouncement = self.addAnnouncementView.exportToAnnouncement()
            AdminOperations.createAnnouncement(finalAnnouncement, completion: { (announcement) -> Void in
                self.navigationController!.popViewControllerAnimated(true)
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
    
    func didSelectSchool(school: School) {
        self.school = school
        self.addAnnouncementView.displayChosenSchool(school)

    }
}
