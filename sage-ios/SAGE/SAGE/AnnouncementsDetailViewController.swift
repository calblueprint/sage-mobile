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
    var announcement: Announcement
    
    override func loadView() {
        let view = AnnouncementsDetailView()
        view.setupWithAnnouncement(announcement)
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = announcement.title
        if let currentID = LoginOperations.getUser()?.id {
            if currentID == self.announcement.sender!.id {
                let editIcon = FAKIonIcons.androidCreateIconWithSize(UIConstants.barbuttonIconSize)
                editIcon.setAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()])
                let editIconImage = editIcon.imageWithSize(CGSizeMake(UIConstants.barbuttonIconSize, UIConstants.barbuttonIconSize))
                let rightButton = UIBarButtonItem(image: editIconImage, style: .Plain, target: self, action: "editAnnouncement")
                self.navigationItem.rightBarButtonItem = rightButton
            }
        }
    }
    
    func editAnnouncement() {
        let editAnnouncementController = EditAnnouncementController()
        editAnnouncementController.configureWithAnnouncement(self.announcement)
        if let topItem = self.navigationController!.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        }
        self.navigationController!.pushViewController(editAnnouncementController, animated: true)
    }
    
    init(announcement: Announcement) {
        self.announcement = announcement
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.announcement = Announcement()
        super.init(coder: aDecoder)
    }
    
}
