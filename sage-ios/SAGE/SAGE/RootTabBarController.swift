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
        let titles = [
            NSLocalizedString("Announcements", comment: "Announcements"),
            NSLocalizedString("Check In", comment: "Check In"),
            NSLocalizedString("Profile", comment: "Profile"),
            NSLocalizedString("Admin", comment: "Admin")
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
        
        var checkInViewController: UIViewController? = nil
        
        // if current semester is nil and user semester is nil
        if (KeychainWrapper.objectForKey(KeychainConstants.kCurrentSemester) == nil && KeychainWrapper.objectForKey(KeychainConstants.kUserSemester) == nil) {
            checkInViewController = JoinSemesterViewController()
        } else {
            checkInViewController = CheckinViewController()
        }
        
        let profileViewController = ProfileViewController(user: LoginOperations.getUser()!)
        
        var rootViewControllers = [announcementsViewController, checkInViewController, profileViewController]
        
        if let role = LoginOperations.getUser()?.role {
            if role == .Admin || role == .Director {
                let icon = FAKIonIcons.folderIconWithSize(UIConstants.tabBarIconSize)
                    .imageWithSize(CGSizeMake(UIConstants.tabBarIconSize, UIConstants.tabBarIconSize))
                images.append(icon)
                
                let adminViewController = AdminTableViewController(style: .Grouped)
                rootViewControllers.append(adminViewController)
            }
        }
        
        var viewControllers = [UIViewController]()
        
        for (var i = 0; i < rootViewControllers.count; i++) {
            let navigationController = UINavigationController()
            navigationController.delegate = self
            navigationController.tabBarItem = UITabBarItem(title: titles[i], image: images[i], tag:i)
            navigationController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3) // Offset to move text up
            // CHANGE THIS BACK TO THE ORIGINAL BY REMOVING THE FORCE UNWRAPPING
            navigationController.viewControllers = [rootViewControllers[i]!]
            
            viewControllers.append(navigationController)
        }
        
        self.viewControllers = viewControllers
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
}
