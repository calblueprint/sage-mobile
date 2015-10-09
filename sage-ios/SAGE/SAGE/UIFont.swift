//
//  UIFont.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/8/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

extension UIFont {
    // metatext: 12
    // normal: 14
    // title: 17 (regular)
    // 20-45 light
    // above 45 thin
    // semibold instead of bold

    @nonobjc static let metaFont = UIFont.systemFontOfSize(12)
    @nonobjc static let normalFont = UIFont.systemFontOfSize(14)
    @nonobjc static let titleFont = UIFont.systemFontOfSize(17)
    
    static func getTitleFont(size: CGFloat = 20) -> UIFont {
        if size < 45 {
            return UIFont(name: ".SFUIDisplay-Light", size: size)!
        } else {
            return UIFont(name: ".SFUIDisplay-Thin", size: size)!
        }
    }
    
    static func getSemiboldFont(size: CGFloat = 20) -> UIFont {
        return UIFont(name: ".SFUIDisplay-Semibold", size: size)!
    }
    
}
