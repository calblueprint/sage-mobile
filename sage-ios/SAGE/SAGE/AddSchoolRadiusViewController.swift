//
//  AddSchoolRadiusViewController.swift
//  SAGE
//
//  Created by Erica Yin on 2/21/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class AddSchoolRadiusViewController: UIViewController {

    var schoolRadiusView = AddSchoolRadiusView(frame: CGRect(), center: CLLocationCoordinate2D(), radius: nil)
    weak var parentVC: AddSchoolController?

    init(center: CLLocationCoordinate2D, radius: CLLocationDistance?) {
        self.schoolRadiusView = AddSchoolRadiusView(frame: CGRect(), center: center, radius: radius)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func loadView() {
        super.loadView()
        self.view = self.schoolRadiusView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Choose Radius"
        let saveButton: UIBarButtonItem = UIBarButtonItem(title: "Finish", style: UIBarButtonItemStyle.Plain, target: self, action: "saveRadius:")
        saveButton.setTitleTextAttributes([NSFontAttributeName: UIFont.getSemiboldFont(17)], forState: .Normal)
        self.navigationItem.rightBarButtonItem = saveButton
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

    func saveRadius(sender: UIBarButtonItem) {
        self.parentVC?.didSelectRadius(CLLocationDistance(self.schoolRadiusView.slider.value))
        self.navigationController?.popViewControllerAnimated(true)
    }

}