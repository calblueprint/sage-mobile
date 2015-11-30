//
//  UIColor.swift
//  SAGE
//
//  Created by Andrew on 9/30/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImageWithUser(user: User) {
        self.contentMode = UIViewContentMode.ScaleAspectFill
        self.image = UIImage.defaultProfileImage()
        if let url = user.imageURL {
            self.setImageWithURL(url)
        }
    }
}
