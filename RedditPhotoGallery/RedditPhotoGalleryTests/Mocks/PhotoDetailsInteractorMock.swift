//
//  PhotoDetailsInteractorMock.swift
//  RedditPhotoGalleryTests
//
//  Created by Matteo Fattori on 08/12/21.
//

import Foundation
@testable import RedditPhotoGallery

class PhotoDetailsInteractorMock: PhotoDetailsInteractor {
    
    public var photoData: Foundation.Data?
    public var receivedUrl: String?
    
    override func getPhotoData(url: String, completionHandler: @escaping (Foundation.Data?) -> ()) {
        self.receivedUrl = url
        completionHandler(self.photoData)
    }
    
}
