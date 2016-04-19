//
//  ExportSemesterViewController.swift
//  SAGE
//
//  Created by Andrew Millman on 4/18/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import Foundation

class ExportSemesterViewController: PastSemestersViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeTitle("Export Semester")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let _ = self.semesters {
            let semester = self.semesters![indexPath.row]
            SemesterOperations.exportSemester(semester, completion: { () -> Void in
                self.navigationController?.popViewControllerAnimated(true)
                }, failure: { (message) -> Void in
                    self.showErrorAndSetMessage(message)
            })
        }
    }
}
