//
//  PhotoDetailsRouterMock.swift
//  RedditPhotoGalleryTests
//
//  Created by Matteo Fattori on 08/12/21.
//

import Foundation
@testable import RedditPhotoGallery

class PhotoDetailsRouterMock: PhotoDetailsRouter {
    
    var dismissCalled: Bool = false
    
    override func dismissModule() {
        self.dismissCalled = true
    }
    
}
