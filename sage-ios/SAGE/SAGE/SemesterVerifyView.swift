//
//  SemesterVerifyView.swift
//  SAGE
//
//  Created by Andrew on 1/1/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

class SemesterVerifyView: UIView {

    private let firstButton = UIView()
    private let secondButton = UIView()
    private let buttonSize: CGFloat = 50.0
    private let buttonMargin: CGFloat = 50.0

    //
    // MARK: - Initialization and Setup
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.setupSubviews()
        self.setupActions()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupSubviews() {
        self.firstButton.backgroundColor = UIColor.lightRedColor
        self.firstButton.setSize(width: self.buttonSize, height: self.buttonSize)
        self.firstButton.layer.cornerRadius = self.buttonSize/2
        self.addSubview(self.firstButton)

        self.secondButton.backgroundColor = UIColor.lightBlueColor
        self.secondButton.setSize(width: self.buttonSize, height: self.buttonSize)
        self.secondButton.layer.cornerRadius = self.buttonSize/2
        self.addSubview(self.secondButton)
    }

    private func setupActions() {

    }

    //
    // MARK: - Layout
    //
    override func layoutSubviews() {
        super.layoutSubviews()

        self.firstButton.setX(self.buttonMargin)
        self.firstButton.alignBottomWithMargin(self.buttonMargin)

        self.secondButton.alignRightWithMargin(self.buttonMargin)
        self.secondButton.alignBottomWithMargin(self.buttonMargin)
    }
}
