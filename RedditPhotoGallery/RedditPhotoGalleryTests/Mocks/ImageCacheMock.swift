//
//  ImageCacheMock.swift
//  RedditPhotoGalleryTests
//
//  Created by Matteo Fattori on 08/12/21.
//

import Foundation
@testable import RedditPhotoGallery

class ImageCacheMock: ImageCache {
    
    var getFromCacheReceivedUrl: String?
    var storeInCacheReceivedUrl: String?
    var receivedImageData: Foundation.Data?
    var imageData: Foundation.Data?
    
    override func getFromCache(url: String) -> Foundation.Data? {
        self.getFromCacheReceivedUrl = url
        return self.imageData
    }
    
    override func storeInCache(url: String, imageData: Foundation.Data) {
        self.storeInCacheReceivedUrl = url
        self.receivedImageData = imageData
    }
    
}
