//
//  SGTableViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 3/2/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

class SGTableViewController: UITableViewController {
    
    var filter: [String: AnyObject]?
    var noContentView = NoContentView()
    var errorView: ErrorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let emptyBackButton = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = emptyBackButton
        
        self.view.addSubview(self.noContentView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.noContentView.fillWidth()
        self.noContentView.fillHeight()
        self.view.bringSubviewToFront(self.noContentView)
    }

    func showNoContentView() {
        if self.noContentView.alpha != 1.0 {
            UIView.animateWithDuration(UIConstants.fastAnimationTime) { () -> Void in
                self.noContentView.alpha = 1.0
            }
        }
    }
    
    func hideNoContentView() {
        if self.noContentView.alpha != 0.0 {
            UIView.animateWithDuration(UIConstants.fastAnimationTime) { () -> Void in
                self.noContentView.alpha = 0.0
            }
        }
    }
    
    func setNoContentMessage(message: String) {
        self.noContentView.setMessageText(message)
    }
    
    func showErrorAndSetMessage(message: String) {
        let error = self.errorView
        let errorView = super.showError(message, currentError: error, color: UIColor.lightRedColor)
        self.errorView = errorView
    }
}
