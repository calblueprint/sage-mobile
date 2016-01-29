//
//  JoinSemesterViewController.swift
//  SAGE
//
//  Created by Erica Yin on 1/29/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class JoinSemesterViewController: UIViewController {

    var joinSemesterView = JoinSemesterView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    var currentErrorMessage: ErrorView?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.joinSemesterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Check In"
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
}
