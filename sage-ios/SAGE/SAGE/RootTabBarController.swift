//
//  RootTabBarController.swift
//  SAGE
//
//  Created by Andrew Millman on 9/28/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit
import FontAwesomeKit
import SwiftKeychainWrapper

class RootTabBarController: UITabBarController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor.mainColor
        self.tabBar.translucent = false
        self.setupTabs()
    }
    
    private func setupTabs() {
        var titles = [
            NSLocalizedString("Announcements", comment: "Announcements"),
            NSLocalizedString("Check In", comment: "Check In"),
            NSLocalizedString("Profile", comment: "Profile")
        ];
        
        var images = [
            FAKIonIcons.radioWavesIconWithSize(UIConstants.tabBarIconSize)
                .imageWithSize(CGSizeMake(UIConstants.tabBarIconSize, UIConstants.tabBarIconSize)),
            FAKIonIcons.locationIconWithSize(UIConstants.tabBarIconSize)
                .imageWithSize(CGSizeMake(UIConstants.tabBarIconSize, UIConstants.tabBarIconSize)),
            FAKIonIcons.personIconWithSize(UIConstants.tabBarIconSize)
                .imageWithSize(CGSizeMake(UIConstants.tabBarIconSize, UIConstants.tabBarIconSize))
        ]

        let announcementsViewController = AnnouncementsViewController(style: .Plain)
        
        let checkInViewController = CheckinViewController()
        
        let profileViewController = ProfileViewController(user: LoginOperations.getUser()!)
        
        var rootViewControllers = [announcementsViewController, checkInViewController, profileViewController]
        
        if let role = LoginOperations.getUser()?.role {
            if role == .Admin || role == .President {
                let icon = FAKIonIcons.folderIconWithSize(UIConstants.tabBarIconSize)
                    .imageWithSize(CGSizeMake(UIConstants.tabBarIconSize, UIConstants.tabBarIconSize))
                images.append(icon)
                titles.append(NSLocalizedString("Admin", comment: "Admin"))
                
                let adminViewController = AdminTableViewController(style: .Grouped)
                rootViewControllers.append(adminViewController)
            } else if let school = KeychainWrapper.objectForKey(KeychainConstants.kSchool) {
                let icon = FAKIonIcons.androidHomeIconWithSize(UIConstants.tabBarIconSize)
                    .imageWithSize(CGSizeMake(UIConstants.tabBarIconSize, UIConstants.tabBarIconSize))
                images.append(icon)
                titles.append(NSLocalizedString("School", comment: "School"))

                let schoolViewController = SchoolDetailViewController()
                schoolViewController.configureWithSchool(school as! School)
                rootViewControllers.append(schoolViewController)
            }
        }
        
        var viewControllers = [UIViewController]()
        
        for (var i = 0; i < rootViewControllers.count; i++) {
            let navigationController = UINavigationController()
            navigationController.delegate = self
            navigationController.tabBarItem = UITabBarItem(title: titles[i], image: images[i], tag:i)
            navigationController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3) // Offset to move text up
            navigationController.viewControllers = [rootViewControllers[i]]
            
            viewControllers.append(navigationController)
        }
        
        self.viewControllers = viewControllers
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
}
