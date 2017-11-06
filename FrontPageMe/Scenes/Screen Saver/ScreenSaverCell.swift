//
//  ScreenSaverCell.swift
//  FrontPageMe
//
//  Created by Adam Lovastyik [Standard] on 06/11/2017.
//  Copyright © 2017 Decos B.V. All rights reserved.
//

import UIKit

class ScreenSaverCell: UICollectionViewCell {
    
    static let reuseId = "ScreenSaverCell"
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    func setup(with image: UIImage) {
    
        photoImageView.image = image
    }
    
}
