//
//  UIImageView.swift
//  SAGE
//
//  Created by Andrew Millman on 2/5/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
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