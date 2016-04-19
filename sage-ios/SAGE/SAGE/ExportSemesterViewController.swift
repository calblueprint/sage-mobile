//
//  ExportSemesterViewController.swift
//  SAGE
//
//  Created by Andrew Millman on 4/18/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class ExportSemesterViewController: PastSemestersViewController {
    
    var loadingButton = SGBarButtonItem(title: nil, style: .Done, target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeTitle("Export Semester")
        self.navigationItem.rightBarButtonItem = self.loadingButton
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let _ = self.semesters {
            self.loadingButton.startLoading()
            let semester = self.semesters![indexPath.row]
            
            SemesterOperations.exportSemester(semester, completion: { () -> Void in
                self.navigationController?.popViewControllerAnimated(true)
                }, failure: { (message) -> Void in
                    self.loadingButton.stopLoading()
                    self.showErrorAndSetMessage(message)
            })
        }
    }
}
