//
//  MenuView.swift
//  SAGE
//
//  Created by Andrew Millman on 2/17/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

class MenuView: UIView {

    var backgroundView = UIView()

    //
    // MARK: - Initialization and Setup
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupSubviews() {
        self.backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.35)
        self.backgroundView.alpha = 0
        self.addSubview(self.backgroundView)
    }

    //
    // MARK: - Public methods
    //
    func appear() {
        UIView.animateWithDuration(UIConstants.normalAnimationTime) { () -> Void in
            self.backgroundView.alpha = 1
        }
    }
}
