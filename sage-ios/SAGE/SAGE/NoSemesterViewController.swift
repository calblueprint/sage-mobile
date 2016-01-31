//
//  NoSemesterViewController.swift
//  SAGE
//
//  Created by Erica Yin on 1/30/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class NoSemesterViewController: UIViewController {
    
    var noSemesterView = NoSemesterView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    var currentErrorMessage: ErrorView?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.noSemesterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
}
