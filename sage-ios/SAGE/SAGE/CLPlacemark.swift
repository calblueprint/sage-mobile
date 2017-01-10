//
//  CLPlacemark.swift
//  SAGE
//
//  Created by Sameera Vemulapalli on 2/23/16.
//  Copyright © 2016 Cal Blueprint. All rights reserved.
//

import UIKit

extension CLPlacemark {
    
    func makeAddressString() -> String {
        var address = ""
        if subThoroughfare != nil { address = subThoroughfare! }
        if thoroughfare != nil { address = address + " " + thoroughfare! }
        if locality != nil { address = address + " " + locality! }
        return address
    }
}
