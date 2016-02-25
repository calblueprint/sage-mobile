//
//  MenuController.swift
//  SAGE
//
//  Created by Andrew Millman on 2/17/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class MenuController: UIViewController {

    var menuView = MenuView()
    var menuList = [MenuItem]()



    //
    // MARK: - Initialization
    //
    required init(title: String?) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        self.modalPresentationStyle = .OverFullScreen
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //
    // MARK: - ViewController LifeCycle
    //
    override func loadView() {
        self.view = self.menuView
        self.menuView.setTitle(self.title)

        let dismissGesture = UITapGestureRecognizer(target: self, action: "dismiss")
        self.menuView.backgroundView.addGestureRecognizer(dismissGesture)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.menuView.createMenuList(self.menuList)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.menuView.appear()
    }

    //
    // MARK: - Public Methods
    //
    func addMenuItem(item: MenuItem) {
        item.controller = self
        self.menuList.append(item)
    }

    func dismiss() {
        self.menuView.disappear { () -> Void in
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
}