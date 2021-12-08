//
//  PhotoGalleryCacheMock.swift
//  RedditPhotoGalleryTests
//
//  Created by Matteo Fattori on 08/12/21.
//

import Foundation
@testable import RedditPhotoGallery

class PhotoGalleryCacheMock: PhotoGalleryCache {
    
    var getFromCacheReceivedQuery: String?
    var storeInCacheReceivedQuery: String?
    var childrensReceived: [ChildrenData]?
    var childrens: [ChildrenData]?
    
    override func getFromCache(query: String) -> [ChildrenData]? {
        self.getFromCacheReceivedQuery = query
        return self.childrens
    }
    
    override func storeInCache(query: String, childrens: [ChildrenData]) {
        self.storeInCacheReceivedQuery = query
        self.childrensReceived = childrens
    }
    
}
