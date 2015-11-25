//
//  BrowseSchoolsDetailViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/21/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class BrowseSchoolsDetailViewController: UIViewController {

    var school: School
    
    init(school: School) {
        self.school = school
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.school.name!
        // Do any additional setup after loading the view.
    }

}