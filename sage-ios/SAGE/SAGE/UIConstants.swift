//
//  UIConstants.swift
//  SAGE
//
//  Created by Andrew on 10/1/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import Foundation

struct UIConstants {
    
    static let profileImageSize : CGFloat = 40.0
    static let sideMargin : CGFloat = 15.0
    static let verticalMargin : CGFloat = 10.0
    static let textMargin : CGFloat = 10.0
    static let navbarHeight : CGFloat = 64.0
    static let barbuttonSize : CGFloat = 44.0
    static let barbuttonIconSize : CGFloat = 24.0
    static let tabBarIconSize : CGFloat = 28.0
    
    static func dividerHeight() -> CGFloat {
        return 1 / UIScreen.mainScreen().scale
    }
}
