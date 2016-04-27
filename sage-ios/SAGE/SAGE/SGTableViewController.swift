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
    private var noContentView = NoContentView()
    private var errorView: ErrorView?
    private var titleView = SGTitleView(title: nil, subtitle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = self.titleView
        
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

    //
    // MARK: - No Content View
    //
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
    
    //
    // MARK: - Error Message
    //
    func showErrorAndSetMessage(message: String) {
        let error = self.errorView
        let errorView = super.showError(message, currentError: error, color: UIColor.lightRedColor)
        self.errorView = errorView
    }
    
    //
    // MARK: - Title
    //
    func setTitle(title: String?, subtitle: String?) {
        self.changeTitle(title)
        self.changeSubtitle(subtitle)
    }
    
    func changeTitle(title: String?) {
        if self.navigationItem.titleView != self.titleView {
            self.navigationItem.titleView = self.titleView
        }
        self.titleView.setTitle(title)
    }
    
    func changeSubtitle(subtitle: String?) {
        if self.navigationItem.titleView != self.titleView {
            self.navigationItem.titleView = self.titleView
        }
        self.titleView.setSubtitle(subtitle)
    }
    
    func removeSubtitle() {
        self.changeSubtitle(nil)
    }
}
