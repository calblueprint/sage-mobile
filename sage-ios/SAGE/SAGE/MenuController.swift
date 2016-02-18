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
        self.menuList.append(item)
    }
}