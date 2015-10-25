//
//  UIView.swift
//  SAGE
//
//  Created by Andrew on 9/30/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

extension UIView {
    
    @nonobjc static let animationTime = 0.3
    
    func setX(x: CGFloat) {
        var frame = self.frame
        frame.origin.x = x
        self.frame = frame
    }
    
    func setY(y: CGFloat) {
        var frame = self.frame
        frame.origin.y = y
        self.frame = frame
    }
    
    func setWidth(width: CGFloat) {
        var frame = self.frame
        frame.size.width = width
        self.frame = frame
    }
    
    func setHeight(height: CGFloat) {
        var frame = self.frame
        frame.size.height = height
        self.frame = frame
    }
    
    func setSize(width: CGFloat, height: CGFloat) {
        var frame = self.frame
        frame.size = CGSizeMake(width, height)
        self.frame = frame
    }
    
    func setSize(size: CGSize) {
        var frame = self.frame
        frame.size = size
        self.frame = frame
    }
    
    func alignRightWithMargin(margin: CGFloat) {
        if (self.superview != nil) {
            var frame = self.frame
            frame.origin.x = CGRectGetWidth(self.superview!.frame) - CGRectGetWidth(self.frame) - margin
            self.frame = frame
        }
    }
    
    func alignBottomWithMargin(margin: CGFloat) {
        if (self.superview != nil) {
            var frame = self.frame
            frame.origin.y = CGRectGetHeight(self.superview!.frame) - CGRectGetHeight(self.frame) - margin
            self.frame = frame
        }
    }
    
    // Fill the view's width to its superview from it's current x origin
    func fillWidth() {
        if (self.superview != nil) {
            var frame = self.frame;
            frame.size.width = CGRectGetWidth(self.superview!.frame) - CGRectGetMinX(self.frame)
            self.frame = frame
        }
    }
    
    func fillWidthWithMargin(margin: CGFloat) {
        if (self.superview != nil) {
            self.fillWidth()
            self.setWidth(CGRectGetWidth(self.frame) - margin)
        }
    }
    
    // Fill the view's height to its superview from it's current y origin
    func fillHeight() {
        if (self.superview != nil) {
            var frame = self.frame
            frame.size.height = CGRectGetHeight(self.superview!.frame) - CGRectGetMinY(self.frame)
            self.frame = frame
        }
    }
    
    func fillHeightWithMargin(margin: CGFloat) {
        if (self.superview != nil) {
            self.fillHeight()
            self.setHeight(CGRectGetHeight(self.frame) - margin)
        }
    }
    
    func centerHorizontally() {
        if (self.superview != nil) {
            self.setX(CGRectGetWidth(self.superview!.frame)/2 - CGRectGetWidth(self.frame)/2)
        }
    }
    
    func centerVertically() {
        if (self.superview != nil) {
            self.setY(CGRectGetHeight(self.superview!.frame)/2 - CGRectGetHeight(self.frame)/2)
        }
    }
}
