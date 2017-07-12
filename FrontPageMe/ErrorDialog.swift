//
//  ErrorDialog.swift
//  FrontPageMe
//
//  Created by Adam Lovastyik [Standard] on 12/07/2017.
//  Copyright © 2017 Decos B.V. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    class func showError(from controller: UIViewController, message: String, dismissedBlock:(() -> ())?) {
        
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Error dialog title"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            dismissedBlock?()
        }))
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    class func showOK(from controller: UIViewController, message: String, dismissedBlock:(() -> ())?) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            dismissedBlock?()
        }))
        
        controller.present(alert, animated: true, completion: nil)
    }
}
