//
//  SGTableViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 3/2/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

class SGTableViewController: UITableViewController {
    
    var noContentView = NoContentView()

    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.noContentView.showMessage(message)
    }

}
