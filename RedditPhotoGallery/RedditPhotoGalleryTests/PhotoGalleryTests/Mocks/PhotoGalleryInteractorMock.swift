//
//  PhotoGalleryInteractorMock.swift
//  RedditPhotoGalleryTests
//
//  Created by Matteo Fattori on 08/12/21.
//

import Foundation
@testable import RedditPhotoGallery

class PhotoGalleryInteractorMock: PhotoGalleryInteractor {
    
    public var childrensData: [ChildrenData] = []
    public var photoData: Foundation.Data?
    public var receivedQuery: String?
    public var receivedUrl: String?
    
    override func getPhotoGallery(query: String, completionHandler: @escaping ([ChildrenData]) -> ()) {
        self.receivedQuery = query
        completionHandler(self.childrensData)
    }
    
    override func getPhotoData(url: String, completionHandler: @escaping (Foundation.Data?) -> ()) {
        self.receivedUrl = url
        completionHandler(self.photoData)
    }
    
}
