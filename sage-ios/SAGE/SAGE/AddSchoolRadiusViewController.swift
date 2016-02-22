//
//  AddSchoolRadiusViewController.swift
//  SAGE
//
//  Created by Erica Yin on 2/21/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class AddSchoolRadiusViewController: UIViewController {

    let defaultCenter = CLLocationCoordinate2D()
    let locationManager = CLLocationManager()
    var schoolRadiusView = AddSchoolRadiusView(frame: CGRect(), center: CLLocationCoordinate2D())
    weak var parentVC: AddSchoolController?

    init(center: CLLocationCoordinate2D) {
        self.schoolRadiusView = AddSchoolRadiusView(frame: CGRect(), center: center)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        self.schoolRadiusView = AddSchoolRadiusView(frame: CGRect(), center: self.defaultCenter)
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func loadView() {
        super.loadView()
        self.view = self.schoolRadiusView
        let saveButton : UIBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "saveRadius:")
        self.navigationItem.rightBarButtonItem = saveButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Set School Radius"
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