//
//  UIColor.swift
//  SAGE
//
//  Created by Andrew on 9/30/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

extension UIColor {
    
    //
    // MARK: - Standard App Coloring
    //
    class func mainColor() -> UIColor {
        return UIColor.colorWithIntRed(255, green: 204, blue: 0, alpha: 1);
    }
    
    class func primaryTextColor() -> UIColor {
        return UIColor.init(white: 0.30, alpha: 1);
    }
    
    class func secondaryTextColor() -> UIColor {
        return UIColor.init(white: 0.85, alpha: 1);
    }
    
    class func borderColor() -> UIColor {
        return UIColor.init(white: 0.80, alpha: 0.90);
    }
    
    
    //
    // MARK: - Extra Flat Colors
    //
    class func lightGreenColor() -> UIColor {
        return UIColor.colorWithIntRed(46, green: 204, blue: 113, alpha: 1);
    }
    
    class func lightRedColor() -> UIColor {
        return UIColor.colorWithIntRed(236, green: 76, blue: 60, alpha: 1);
    }
    
    
    //
    // MARK: - Helper Methods
    //
    class func colorWithIntRed(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha);
    }
}
