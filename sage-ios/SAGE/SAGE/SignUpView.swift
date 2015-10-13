//
//  SignUpView.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 10/10/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

class SignUpView: UIScrollView, UIScrollViewDelegate {
    
    var pageControl: UIPageControl = UIPageControl()
    var gestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    var nameView = SignUpNameView()
    var emailPasswordView = SignUpEmailPasswordView()
    var schoolHoursView = SignUpSchoolHoursView()
    var photoView = SignUpPhotoView()
    var allViews = [SignUpFormView]()
    
    override init(frame: CGRect) {
        let screenRect = UIScreen.mainScreen().bounds;
        let screenWidth = screenRect.size.width;
        let screenHeight = screenRect.size.height;
        let newFrame = CGRectMake(0, 0, screenWidth, screenHeight)
        super.init(frame: newFrame)
        self.setUpViews()
        self.delegate = self
    }
    
    func setUpViews() {
        self.pagingEnabled = true
        self.scrollsToTop = false
        self.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * 4, CGRectGetHeight(self.frame))
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.pageControl.numberOfPages = 4
        self.pageControl.currentPage = 0
        
        let screenRect = UIScreen.mainScreen().bounds;
        let screenWidth = screenRect.size.width;
        
        self.addSubview(self.nameView)
        self.addSubview(self.emailPasswordView)
        self.addSubview(self.schoolHoursView)
        self.addSubview(self.photoView)
        self.addSubview(self.pageControl)
        self.bringSubviewToFront(self.pageControl)
        
        self.allViews.append(self.nameView)
        self.allViews.append(self.emailPasswordView)
        self.allViews.append(self.schoolHoursView)
        self.allViews.append(self.photoView)
        
        self.nameView.setX(0)
        self.emailPasswordView.setX(screenWidth)
        self.schoolHoursView.setX(2 * screenWidth)
        self.photoView.setX(3 * screenWidth)
        
        self.nameView.backgroundColor = UIColor.lightRedColor
        self.emailPasswordView.backgroundColor = UIColor.lightOrangeColor
        self.schoolHoursView.backgroundColor = UIColor.lightYellowColor
        self.photoView.backgroundColor = UIColor.lightGreenColor
        
        // any view setup goes here
    }
    
    override func layoutSubviews() {
        self.pageControl.sizeToFit()
        self.pageControl.centerHorizontally()
        self.pageControl.setY(225)
    }
    
    func calculateColor(firstColor: UIColor, secondColor: UIColor, offset: CGFloat) -> UIColor {
        let firstCIColor = CIColor(color: firstColor)
        let secondCIColor = CIColor(color: secondColor)
        let red = firstCIColor.red * (1 - offset) + secondCIColor.red * offset
        let green = firstCIColor.green * (1 - offset) + secondCIColor.green * offset
        let blue = firstCIColor.blue * (1 - offset) + secondCIColor.blue * offset
        let newColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        return newColor
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let screenRect = UIScreen.mainScreen().bounds;
        let screenWidth = screenRect.size.width;
        let colorIndex = Int(offset / screenWidth)
        let colorOffset = (offset % screenWidth) / screenWidth
        self.pageControl.currentPage = colorIndex
            
        let colors = [UIColor.lightRedColor, UIColor.lightOrangeColor, UIColor.lightYellowColor, UIColor.lightGreenColor, UIColor.lightGreenColor]
        UIView.animateWithDuration(UIView.animationTime, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            for formView in self.allViews {
                formView.backgroundColor = self.calculateColor(colors[colorIndex], secondColor: colors[colorIndex + 1], offset: colorOffset)
            }
            }, completion: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
