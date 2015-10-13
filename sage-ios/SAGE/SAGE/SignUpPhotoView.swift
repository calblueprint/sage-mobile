//
//  SignUpPhotoView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/10/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class SignUpPhotoView: SignUpFormView {
    var photoButton: UIButton = UIButton()
    var skipAndFinishLink: UIButton = UIButton()
    var finishButton: UIButton = UIButton()
    
    override func setUpViews() {
        super.setUpViews()
        self.containerView.addSubview(self.photoButton)
        self.containerView.addSubview(self.skipAndFinishLink)
        self.containerView.addSubview(self.finishButton)
        
        self.headerLabel.text = "One last step!"
        self.subHeaderLabel.text = "Let's put a face to you!"
        self.skipAndFinishLink.titleLabel!.text = "Skip and finish"
        self.finishButton.titleLabel!.text = "Finish"
    }
}
