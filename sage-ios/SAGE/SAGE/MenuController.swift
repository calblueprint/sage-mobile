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
        self.menuView.setTitle("Filter Options")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.menuView.createMenuList(self.menuList)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .Default
        self.menuView.appear()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

    //
    // MARK: - Public Methods
    //
    func addMenuItem(item: MenuItem) {
        self.menuList.append(item)
    }
}