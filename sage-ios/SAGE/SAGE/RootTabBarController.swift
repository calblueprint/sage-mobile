//
//  RootTabBarController.swift
//  SAGE
//
//  Created by Andrew Millman on 9/28/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor.mainColor()
        self.tabBar.translucent = false
        
        self.setupTabs()
    }
    
    private func setupTabs() {
        let titles = [
            NSLocalizedString("Announcements", comment: "Announcements"),
            NSLocalizedString("Check In", comment: "Check In"),
            NSLocalizedString("My Stats", comment: "My Stats"),
            NSLocalizedString("Profile", comment: "Profile")
        ];
        
        let images = [
            FAKIonIcons.radioWavesIconWithSize(28).imageWithSize(CGSizeMake(28,28)),
            FAKIonIcons.locationIconWithSize(28).imageWithSize(CGSizeMake(28,28)),
            FAKIonIcons.statsBarsIconWithSize(28).imageWithSize(CGSizeMake(28,28)),
            FAKIonIcons.personIconWithSize(28).imageWithSize(CGSizeMake(28,28))
        ]
        
        let announcementsViewController = UIViewController()
        let checkInViewController = UIViewController()
        let myStatsViewController = UIViewController()
        let profileViewController = UIViewController()
        
        let rootViewControllers = [announcementsViewController, checkInViewController, myStatsViewController, profileViewController]
        
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
}
