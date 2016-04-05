//
//  SGViewController.swift
//  SAGE
//
//  Created by Andrew Millman on 4/2/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class SGViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let emptyBackButton = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = emptyBackButton        
    }
}
