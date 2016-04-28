//
//  UINavigationController.swift
//  SAGE
//
//  Created by Andrew Millman on 4/27/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

extension UINavigationController {

    func showSuccess(message: String, currentSuccess: SuccessView?, color: UIColor = UIColor.whiteColor(), alpha: CGFloat? = 1.0, centered: Bool? = true) -> SuccessView {
        if currentSuccess != nil {
            currentSuccess?.removeFromSuperview()
        }

        let size: CGFloat = 44.0
        let successView = SuccessView(height: size, messageString: message, color: color, alpha: alpha, centered: centered)
        self.view.insertSubview(successView, belowSubview: self.navigationBar)
        successView.layoutSubviews()
        successView.setX(0)
        successView.setY(-10)

        UIView.animateWithDuration(UIView.animationTime, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            successView.setY(UIConstants.navbarHeight)
            }) { (bool) -> Void in
                UIView.animateWithDuration(UIView.animationTime, delay: 3, options: .CurveLinear, animations: { () -> Void in
                    successView.alpha = 0.0
                    successView.setY(-1 * size)
                    }, completion: nil)
        }
        return successView
    }
}
