//
//  PhotoGalleryViewControllerMock.swift
//  RedditPhotoGalleryTests
//
//  Created by Matteo Fattori on 08/12/21.
//

import Foundation
@testable import RedditPhotoGallery

class PhotoGalleryViewControllerMock: PhotoGalleryViewController {
    
    public var receivedViewModels: [PhotoGalleryViewModel] = []
    
    override func renderViewModel(viewModel: PhotoGalleryViewModel) {
        self.receivedViewModels.append(viewModel)
    }
    
}
