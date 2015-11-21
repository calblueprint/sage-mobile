//
//  CheckinRequestsDetailViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class CheckinRequestsDetailViewController: UIViewController {

    var checkin: Checkin
    
    init(checkin: Checkin) {
        self.checkin = checkin
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.checkin.user!.firstName! + " " + self.checkin.user!.lastName!
        // Do any additional setup after loading the view.
    }

}
