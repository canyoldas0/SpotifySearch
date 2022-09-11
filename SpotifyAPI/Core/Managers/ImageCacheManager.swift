//
//  ImageCacheManager.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 3.09.2022.
//

import UIKit

class ImageCacheManager {
    
    private static let imageCache = NSCache<NSString, UIImage>()
    
    class func setImagesToCache(object: UIImage, key: String) {
        imageCache.setObject(object, forKey: NSString(string: key))
    }
    
    class func returnImagesFromCache(key: String) -> UIImage? {
        return imageCache.object(forKey: NSString(string: key))
    }
    
    class func removeImageCache() {
        imageCache.removeAllObjects()
    }
}
