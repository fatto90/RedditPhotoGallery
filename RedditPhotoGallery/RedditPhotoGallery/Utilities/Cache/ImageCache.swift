//
//  ImageCache.swift
//  RedditPhotoGallery
//
//  Created by Matteo Fattori on 08/12/21.
//

import Foundation

class ImageCache {
    
    // MARK: Properties
    
    static let shared = ImageCache()
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    //MARK: Public members
    
    public func getFromCache(url: String) -> Foundation.Data? {
        var result: Foundation.Data? = nil
        
        if let cachedImageData = self.userDefaults.object(forKey: url) as? Foundation.Data {
            result = cachedImageData
        }
        
        return result
    }
    
    public func storeInCache(url: String, imageData: Foundation.Data) {
        self.userDefaults.set(imageData, forKey: url)
    }
    
    //MARK: Private members
    
}
