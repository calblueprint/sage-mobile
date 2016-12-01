//
//  UIColor.swift
//  SAGE
//
//  Created by Andrew on 9/30/15.
//  Copyright © 2015 Cal Blueprint. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func encodedPhotoString(image: UIImage) -> String {
        let png = UIImagePNGRepresentation(self.compressForUpload(image, withScale: 0.2))
        let pngString = (png?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength))!
        return pngString
    }
    
    static func compressForUpload(original: UIImage, withScale scale: CGFloat) -> UIImage {
        let originalSize = original.size
        let newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale)
        UIGraphicsBeginImageContext(newSize)
        original.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let compressedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return compressedImage!
    }
    
    static func defaultProfileImage() -> UIImage {
       return UIImage(named: "profiledefault")!;
    }
}
