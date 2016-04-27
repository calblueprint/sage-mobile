//
//  SGLoadingCell.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 4/2/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

class SGLoadingCell: UITableViewCell {
    static let cellHeight: CGFloat = 44.0
    var loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.loadingIndicator)
        self.backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating() {
        self.loadingIndicator.startAnimating()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.loadingIndicator.centerHorizontally()
        self.loadingIndicator.centerVertically()
    }

}
