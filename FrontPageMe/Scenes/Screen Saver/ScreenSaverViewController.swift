//
//  ScreenSaverViewController.swift
//  FrontPageMe
//
//  Created by Adam Lovastyik [Standard] on 06/11/2017.
//  Copyright © 2017 Decos B.V. All rights reserved.
//

import UIKit

class ScreenSaverViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    private struct layout {
        
        struct portrait {
            
            static let columns  = 5
            static let rows     = 4
        }
        
        struct landscape {
            
            static let columns  = 7
            static let rows     = 3
        }
    }

    class func controller() -> ScreenSaverViewController {
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScreenSaverViewController") as! ScreenSaverViewController
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signupForImageCacheNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
        resignFromImageCacheNotification()
    }
    
    // MARK: - Collection View

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return ImageCache.shared.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScreenSaverCell.reuseId, for: indexPath) as! ScreenSaverCell
        
        let photo = ImageCache.shared.photos[indexPath.item]
        
        cell.setup(with: photo)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let orientation = UIDevice.current.orientation
        
        let rows = CGFloat(orientation.isPortrait ? layout.portrait.rows : layout.landscape.rows)
        let columns = CGFloat(orientation.isPortrait ? layout.portrait.columns : layout.landscape.columns)
        
        let size = CGSize(width: collectionView.bounds.size.width / columns, height: collectionView.bounds.size.height / rows)
        
        return size
    }
    
    // MARK: - Notifications
    
    private func signupForImageCacheNotification() {
    
        NotificationCenter.default.addObserver(self, selector: #selector(imageCacheNotificationReceived(notification:)), name: Notification.Name(ImageCache.PhotoFetchCompletedNotificationName), object: nil)
    }
    
    private func resignFromImageCacheNotification() {
    
        NotificationCenter.default.removeObserver(self, name: Notification.Name(ImageCache.PhotoFetchCompletedNotificationName), object: nil)
    }
    
    @objc func imageCacheNotificationReceived(notification: Notification) {
        
        DispatchQueue.main.async {
            
            self.photoCollectionView.reloadData()
        }
    }
}
