//
//  RequestHoursViewController.swift
//  SAGE
//
//  Created by Andrew on 10/27/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

class RequestHoursViewController: UIViewController {
    
    var requestHoursView = RequestHoursView()
    
    //
    // MARK: - ViewController Lifecycle
    //
    override func loadView() {
        self.view = self.requestHoursView
    }
    
}
