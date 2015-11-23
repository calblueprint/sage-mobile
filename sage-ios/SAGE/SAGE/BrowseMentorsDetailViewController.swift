//
//  BrowseMentorsDetailViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class BrowseMentorsDetailViewController: UIViewController {

    var mentor: User
    
    init(mentor: User) {
        self.mentor = mentor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.mentor.firstName! + " " + self.mentor.lastName!
        // Do any additional setup after loading the view.
    }
}
