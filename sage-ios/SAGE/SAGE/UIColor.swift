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
    @nonobjc static let mainColor =  UIColor.colorWithIntRed(255, green: 195, blue: 41, alpha: 1)
    @nonobjc static let secondaryTextColor = UIColor(white: 0.78, alpha: 1)
    @nonobjc static let borderColor = UIColor(white: 0.80, alpha: 0.90)
    @nonobjc static let lightGreenColor = UIColor.colorWithIntRed(46, green: 204, blue: 113, alpha: 1)
    @nonobjc static let lightRedColor = UIColor.colorWithIntRed(236, green: 76, blue: 60, alpha: 1)
    @nonobjc static let lightOrangeColor = UIColor.colorWithIntRed(245, green: 146, blue: 35, alpha: 1)
    @nonobjc static let lightYellowColor = UIColor.colorWithIntRed(255, green: 195, blue: 41, alpha: 1)
    @nonobjc static let lightBlueColor = UIColor.colorWithIntRed(74, green: 144, blue: 226, alpha: 1)
    @nonobjc static let turquoiseColor = UIColor.colorWithIntRed(26, green: 188, blue: 156, alpha: 1)
    @nonobjc static let lightPurpleColor = UIColor.colorWithIntRed(155, green: 89, blue: 182, alpha: 1)
    @nonobjc static let lightGrayColor = UIColor(white: 0.7, alpha: 1)
    @nonobjc static let lighterGrayColor = UIColor(white: 0.9, alpha: 1)
    
    //
    // MARK: - Helper Methods
    //
    class func colorWithIntRed(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha);
    }
}
