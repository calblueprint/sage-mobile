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
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        self.joinSemesterView.button.addTarget(self, action: "joinSemester:", forControlEvents: .TouchUpInside)
    }
    
    func joinSemester(sender: UIButton!) {
        SemesterOperations.joinSemester({ () -> Void in
            self.navigationController!.popViewControllerAnimated(false)
            }) { (errorMessage) -> Void in
                // error
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
}
