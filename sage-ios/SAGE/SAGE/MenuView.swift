//
//  MenuView.swift
//  SAGE
//
//  Created by Andrew Millman on 2/17/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

class MenuView: UIView {
    
    private var backgroundView = UIView()
    private var menuList: [MenuItem]?
    
    static let menuItemHeight: CGFloat = 60.0
    
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
    // MARK: - Layout
    //
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView.frame = self.bounds
        
        let startingOffset = UIConstants.navbarHeight
        if let list = self.menuList {
            for var i = 0; i < list.count; i++ {
                let menuItem = list[i]
                menuItem.setY(startingOffset + MenuView.menuItemHeight*CGFloat(i))
                menuItem.fillWidth()
            }
        }
    }
    
    //
    // MARK: - Public methods
    //
    func createMenuList(list: [MenuItem]) {
        if self.menuList == nil {
            self.menuList = list
            for menuItem in list {
                self.addSubview(menuItem)
            }
            self.layoutSubviews()
        }
    }
    
    func appear() {
        UIView.animateWithDuration(UIConstants.normalAnimationTime) { () -> Void in
            self.backgroundView.alpha = 1
        }
        
        let itemOffset: CGFloat = 200
        for var i = 0; i < self.menuList?.count; i++ {
            let menuItem = self.menuList![i]
            menuItem.moveY(itemOffset)
            UIView.animateWithDuration(UIConstants.longAnimationTime,
                delay: Double(i) * 0.10,
                usingSpringWithDamping: UIConstants.defaultSpringDampening,
                initialSpringVelocity: UIConstants.defaultSpringVelocity,
                options: [],
                animations: { () -> Void in
                    menuItem.moveY(-itemOffset)
                },
                completion: nil)
        }
        
    }
}
