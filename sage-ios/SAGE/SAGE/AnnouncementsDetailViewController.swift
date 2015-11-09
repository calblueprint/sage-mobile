//
//  AnnouncementsDetailViewController.swift
//  SAGE
//
//  Created by Erica Yin on 11/7/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class AnnouncementsDetailViewController: UIViewController {
    var announcement: Announcement
    
    override func loadView() {
        var view = AnnouncementsDetailView()
        view.setupWithAnnouncement(announcement)
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = announcement.title
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
