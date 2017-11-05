//
//  UIFont.swift
//  FrontPageMe
//
//  Created by Adam Lovastyik [Standard] on 12/07/2017.
//  Copyright © 2017 Decos B.V. All rights reserved.
//

import Foundation
import UIKit

enum FontStyle:String {
    
    case regular    = "Regular"
    case bold       = "Bold"
    case light      = "Light"
    case italic     = "Italic"
    case semiBold   = "Semibold"
}

extension UIFont {
    
    // MARK: - Helpers
    
    class func defaultFont(style fontStyle: FontStyle, size: CGFloat) -> UIFont {
        
        let fontName = "OpenSans-" + fontStyle.rawValue
        
        var font  = UIFont(name: fontName, size: size)
        
        if font == nil {
            // Fall back to system font
            font = UIFont.systemFont(ofSize: size)
        }
        
        return font!
    }
    
    class func installedFonts() {
        
        for family in UIFont.familyNames {
            print("\(family)")
            let fam: String = family
            for name in UIFont.fontNames(forFamilyName: fam) {
                print("\t\(name)")
            }
        }
    }
}
