//
//  SGButton.swift
//  SAGE
//
//  Created by Andrew on 11/30/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class SGButton: UIButton {

    var loadingView = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadingView.color = UIColor.redColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //
    // MARK: - Public Methods
    //
    func isLoading() -> Bool {
        return self.loadingView.isAnimating()
    }

    func startLoading() {
        self.titleLabel?.alpha = 0
        self.imageView?.alpha = 0
        self.loadingView.startAnimating()
    }

    func stopLoading() {
        self.titleLabel?.alpha = 1
        self.imageView?.alpha = 1
        self.loadingView.stopAnimating()
    }

    func setThemeColor(color: UIColor) {
        self.setTitleColor(color, forState: .Normal)
        self.loadingView.color = color
    }
}
