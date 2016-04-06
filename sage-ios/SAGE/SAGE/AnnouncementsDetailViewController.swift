//
//  AnnouncementsDetailViewController.swift
//  SAGE
//
//  Created by Erica Yin on 11/7/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation
import FontAwesomeKit

class AnnouncementsDetailViewController: UIViewController {
    
    var announcement = Announcement()
    var detailView = AnnouncementsDetailView()
    
    //
    // MARK: - Initialization
    //
    init() {
        super.init(nibName: nil, bundle: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "announcementEdited:", name: NotificationConstants.editAnnouncementKey, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    convenience init(announcement: Announcement) {
        self.init()
        self.announcement = announcement.copy() as! Announcement
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //
    // MARK: - View Controller Lifecycle
    //
    override func loadView() {
        self.view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = announcement.title
        self.detailView.setupWithAnnouncement(self.announcement)
        if let currentID = LoginOperations.getUser()?.id {
            if currentID == self.announcement.sender!.id {
                let editIcon = FAKIonIcons.androidCreateIconWithSize(UIConstants.barbuttonIconSize)
                editIcon.setAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()])
                let editIconImage = editIcon.imageWithSize(CGSizeMake(UIConstants.barbuttonIconSize, UIConstants.barbuttonIconSize))
                let rightButton = UIBarButtonItem(image: editIconImage, style: .Plain, target: self, action: "editAnnouncement")
                self.navigationItem.rightBarButtonItem = rightButton
            }
        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "showProfile")
        self.detailView.announcementUserImg.addGestureRecognizer(tapGestureRecognizer)
    }

    func showProfile() {
        if let sender = self.announcement.sender {
            let profileViewController = ProfileViewController(user: sender)
            self.navigationController?.pushViewController(profileViewController, animated: true)

        }
    }
    
    //
    // MARK: - Button Actions
    //
    func editAnnouncement() {
        let editAnnouncementController = EditAnnouncementController()
        editAnnouncementController.configureWithAnnouncement(self.announcement)
        self.navigationController!.pushViewController(editAnnouncementController, animated: true)
    }
    
    //
    // MARK: - Notifications
    //
    func announcementEdited(notification: NSNotification) {
        let newAnnouncement = notification.object!.copy() as! Announcement
        if newAnnouncement.id == self.announcement.id {
            self.announcement = newAnnouncement
            self.detailView.setupWithAnnouncement(self.announcement)
        }
    }
}
