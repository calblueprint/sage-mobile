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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.menuView.appear()
    }
}