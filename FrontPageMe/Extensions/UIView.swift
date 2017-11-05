//
//  UIView.swift
//  FrontPageMe
//
//  Created by Adam Lovastyik [Standard] on 12/07/2017.
//  Copyright © 2017 Decos B.V. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    public func getSnapshotImage() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let snapshotImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return snapshotImage
    }
}
