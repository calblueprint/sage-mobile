//
//  UIViewController.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 11/7/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showError(message: String, size: CGFloat, currentError: ErrorView?) -> ErrorView {
        if currentError != nil {
            currentError?.removeFromSuperview()
        }

        let errorView = ErrorView(height: size, messageString: message)
        self.view.addSubview(errorView)
        self.view.bringSubviewToFront(errorView)
        errorView.setX(0)
        errorView.setY(-10)
        
        UIView.animateWithDuration(UIView.animationTime, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                errorView.setY(0)
            }) { (bool) -> Void in
                UIView.animateWithDuration(UIView.animationTime, delay: 3, options: .CurveLinear, animations: { () -> Void in
                    errorView.alpha = 0.0
                    errorView.setY(-1 * size)
                    }, completion: nil)
            }
        return errorView
    }
}
