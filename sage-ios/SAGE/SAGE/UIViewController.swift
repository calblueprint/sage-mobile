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
    func showError(message: String, currentError: ErrorView?, color: UIColor = UIColor.whiteColor(), alpha: CGFloat? = 1.0, centered: Bool? = true) -> ErrorView {
        if currentError != nil {
            currentError?.removeFromSuperview()
        }
        var size: CGFloat
        if let _ = self.navigationController {
            size = 44.0
        } else {
            size = 64.0
        }
        let errorView = ErrorView(height: size, messageString: message, color: color, alpha: alpha)
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
    
    func showAlertControllerError(errorMessage: String) {
        let alertController = UIAlertController(
            title: "Failure",
            message: errorMessage,
            preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
