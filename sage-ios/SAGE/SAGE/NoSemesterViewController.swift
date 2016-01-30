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
        self.view = self.noSemesterView
        self.title = "Check In"
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
}
