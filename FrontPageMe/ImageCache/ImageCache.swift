//
//  ImageCache.swift
//  FrontPageMe
//
//  Created by Adam Lovastyik [Standard] on 06/11/2017.
//  Copyright © 2017 Decos B.V. All rights reserved.
//

import Foundation
import Photos

class ImageCache {
    
    static let shared = ImageCache()
    
    static let PhotoFetchCompletedNotificationName = "PhotoFetchCompleted"
    
    private let totalImageCountNeeded = 200
    
    private var _photos = [UIImage]()
    
    var photos: [UIImage] {
        
        get {
            
            return _photos
        }
    }
    
    func fetchPhotos() {
        
        let imgManager = PHImageManager.default()
        
        // Note that if the request is not set to synchronous
        // the requestImageForAsset will return both the image
        // and thumbnail; by setting synchronous to true it
        // will return just the thumbnail
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        // Sort the images by creation date
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        if #available(iOS 9.0, *) {
            fetchOptions.fetchLimit = totalImageCountNeeded
        }
        
        DispatchQueue.global(qos: .background).async {
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            var index = 0
            
            var tempPhotos = [UIImage]()
            
            let width = UIScreen.main.bounds.size.width * UIScreen.main.scale;
            let height = UIScreen.main.bounds.size.height * UIScreen.main.scale
            
            let maxSize = max(width, height)
            
            let size = CGSize(width: maxSize, height: maxSize)
            
            while index < self.totalImageCountNeeded && index < fetchResult.count {
                
                let asset = fetchResult.object(at: index)
                
                imgManager.requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
                    
                    if image != nil {
                    
                        tempPhotos.append(image!)
                    }
                })
                
                index += 1
            }
            
            self._photos = tempPhotos
            NotificationCenter.default.post(name: Notification.Name(ImageCache.PhotoFetchCompletedNotificationName), object: self)
        }
    }
}
