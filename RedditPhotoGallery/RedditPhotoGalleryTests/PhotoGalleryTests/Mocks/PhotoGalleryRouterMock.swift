//
//  PhotoGalleryRouterMock.swift
//  RedditPhotoGalleryTests
//
//  Created by Matteo Fattori on 08/12/21.
//

import Foundation
@testable import RedditPhotoGallery

class PhotoGalleryRouterMock: PhotoGalleryRouter {
    
    var receivedImages: [PhotoImageViewModel]?
    var receivedIndex: Int?
    
    override func showPhotoDetails(images: [PhotoImageViewModel], index: Int) {
        self.receivedImages = images
        self.receivedIndex = index
    }
    
}
