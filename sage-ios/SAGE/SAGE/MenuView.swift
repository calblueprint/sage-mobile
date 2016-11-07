//
//  MenuView.swift
//  SAGE
//
//  Created by Andrew Millman on 2/17/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit
import FontAwesomeKit

class MenuView: UIView {

    var backgroundView = UIView()
    var closeButton = UIButton()
    private var menuList: [MenuItem]?
    private var navbar = UINavigationBar()
    private var darkenStatusBar = false

    static let menuItemHeight: CGFloat = 60.0

    //
    // MARK: - Initialization and Setup
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupSubviews() {
        self.backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.40)
        self.backgroundView.alpha = 0
        self.addSubview(self.backgroundView)

        self.navbar.translucent = false
        self.navbar.barTintColor = UIColor.whiteColor()
        self.navbar.tintColor = UIColor.blackColor()
        self.navbar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        self.navbar.layer.shadowOffset = CGSizeMake(0, 3)
        self.navbar.layer.shadowRadius = 2
        self.navbar.layer.shadowOpacity = 0.15
        self.navbar.alpha = 0
        self.navbar.setHeight(UIConstants.navbarHeight)
        self.addSubview(self.navbar)

        self.closeButton.setWidth(UIConstants.barbuttonSize)
        self.closeButton.setHeight(UIConstants.barbuttonSize)
        let filterIcon = FAKIonIcons.androidCloseIconWithSize(UIConstants.barbuttonIconSize)
        let filterImage = filterIcon.imageWithSize(CGSizeMake(UIConstants.barbuttonIconSize, UIConstants.barbuttonIconSize))
        self.closeButton.setImage(filterImage, forState: .Normal)
        self.navbar.addSubview(self.closeButton)
    }

    //
    // MARK: - Layout
    //
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView.frame = self.bounds

        self.navbar.fillWidth()
        self.closeButton.alignRightWithMargin(0)
        self.closeButton.alignBottomWithMargin(0)

        let startingOffset = UIConstants.navbarHeight
        if let list = self.menuList {
<<<<<<< HEAD
            for var i = 0; i < list.count; i += 1 {
=======
            for i in 0..<list.count {
>>>>>>> master
                let menuItem = list[i]
                menuItem.setY(startingOffset + MenuView.menuItemHeight*CGFloat(i))
                menuItem.fillWidth()
            }
        }
    }

    //
    // MARK: - Public methods
    //
    func setTitle(title: String?) {
        if title == nil || title!.characters.count == 0 {
            self.navbar.translucent = true
            self.navbar.barTintColor = UIColor.clearColor()
            self.navbar.tintColor = UIColor.whiteColor()
            self.navbar.layer.shadowOpacity = 0

            self.closeButton.setWidth(UIConstants.barbuttonSize)
            self.closeButton.setHeight(UIConstants.barbuttonSize)
            let filterIcon = FAKIonIcons.androidCloseIconWithSize(UIConstants.barbuttonIconSize)
            filterIcon.setAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()])
            let filterImage = filterIcon.imageWithSize(CGSizeMake(UIConstants.barbuttonIconSize, UIConstants.barbuttonIconSize))
            self.closeButton.setImage(filterImage, forState: .Normal)

            self.darkenStatusBar = false
            return
        }
        let navigationItem = UINavigationItem(title: title!)
        self.navbar.setItems([navigationItem], animated: false)
        self.darkenStatusBar = true
    }

    func createMenuList(list: [MenuItem]) {
        if self.menuList == nil {
            self.menuList = list
            for menuItem in list {
                menuItem.alpha = 0
                self.insertSubview(menuItem, atIndex: 1)
            }
            self.layoutSubviews()
        }
    }

    func appear() {
        if self.darkenStatusBar {
            UIApplication.sharedApplication().statusBarStyle = .Default
        }

        UIView.animateWithDuration(UIConstants.normalAnimationTime) { () -> Void in
            self.backgroundView.alpha = 1
        }

        self.navbar.moveY(-UIConstants.navbarHeight)
        self.navbar.alpha = 1
        UIView.animateWithDuration(UIConstants.longAnimationTime,
            delay: 0,
            usingSpringWithDamping: UIConstants.defaultSpringDampening,
            initialSpringVelocity: UIConstants.defaultSpringVelocity,
            options: [],
            animations: { () -> Void in
                self.navbar.moveY(UIConstants.navbarHeight)
            },
            completion: nil)


        let itemOffset: CGFloat = 200
<<<<<<< HEAD
        for var i = 0; i < self.menuList?.count; i += 1 {
=======
//        for var i = 0; i < self.menuList?.count; i += 1 {
        for i in 0..<self.menuList!.count {
>>>>>>> master
            let menuItem = self.menuList![i]
            menuItem.moveY(itemOffset)
            UIView.animateWithDuration(UIConstants.longAnimationTime,
                delay: Double(i) * 0.10,
                usingSpringWithDamping: UIConstants.defaultSpringDampening,
                initialSpringVelocity: UIConstants.defaultSpringVelocity,
                options: [],
                animations: { () -> Void in
                    menuItem.alpha = 1
                    menuItem.moveY(-itemOffset)
                },
                completion: nil)
        }
    }

    func disappear(completion: () -> Void) {
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)

        UIView.animateWithDuration(UIConstants.normalAnimationTime) { () -> Void in
            self.backgroundView.alpha = 0
        }

        UIView.animateWithDuration(UIConstants.fastAnimationTime, animations: { () -> Void in
            self.navbar.moveY(-UIConstants.navbarHeight-10)
        }, completion: nil)

        let itemOffset: CGFloat = 200
<<<<<<< HEAD
        for var i = self.menuList!.count - 1; i >= 0; i -= 1 {
=======
        for i in (self.menuList!.count - 1).stride(through: 0, by: -1) {
>>>>>>> master
            let menuItem = self.menuList![i]
            let delay = Double(self.menuList!.count - 1 - i) * 0.07
            UIView.animateWithDuration(UIConstants.normalAnimationTime,
                delay: delay,
                options: [],
                animations: { () -> Void in
                    menuItem.alpha = 0
            }, completion: nil)

            UIView.animateWithDuration(UIConstants.longAnimationTime,
                delay: delay,
                options: [],
                animations: { () -> Void in
                    menuItem.moveY(itemOffset*2)
                }) { (completed) -> Void in
                    if (menuItem == self.menuList?.first) {
                        completion()
                    }
                }
        }
    }
}
