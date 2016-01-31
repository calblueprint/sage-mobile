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
        self.joinSemesterView.button.startLoading()
        SemesterOperations.joinSemester({ () -> Void in
            self.joinSemesterView.button.stopLoading()
            self.navigationController!.popViewControllerAnimated(false)
            }) { (errorMessage) -> Void in
                self.joinSemesterView.button.stopLoading()
                let alertController = UIAlertController(
                    title: "Failure",
                    message: errorMessage as String,
                    preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
}
