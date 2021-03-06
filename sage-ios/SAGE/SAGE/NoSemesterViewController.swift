//
//  NoSemesterViewController.swift
//  SAGE
//
//  Created by Erica Yin on 1/30/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class NoSemesterViewController: SGViewController {
    
    var noSemesterView = NoSemesterView()
    
    //
    // MARK: - Initialization
    //
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NoSemesterViewController.semesterStarted(_:)), name: NotificationConstants.startSemesterKey, object: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    // MARK: - ViewController Life Cycle
    //
    override func loadView() {
        super.loadView()
        self.view = self.noSemesterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
    }
    
    //
    // MARK: - NSNotificationCenter Handlers
    //
    func semesterStarted(notification: NSNotification) {
        self.navigationController?.popViewControllerAnimated(false)
    }
}
