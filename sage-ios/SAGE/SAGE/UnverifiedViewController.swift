//
//  UnverifiedViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/6/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class UnverifiedViewController: UIViewController {
    
    override func loadView() {
        self.view = UnverifiedView()
    }
    
    func setImage(image: UIImage) {
        (self.view as! UnverifiedView).photo.contentMode = UIViewContentMode.ScaleAspectFill
        (self.view as! UnverifiedView).photo.image = image
    }
}
