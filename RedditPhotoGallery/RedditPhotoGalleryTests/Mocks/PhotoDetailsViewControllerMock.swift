//
//  PhotoDetailsViewControllerMock.swift
//  RedditPhotoGalleryTests
//
//  Created by Matteo Fattori on 08/12/21.
//

import Foundation
@testable import RedditPhotoGallery

class PhotoDetailsViewControllerMock: PhotoDetailsViewController {
    
    public var receivedViewModels: [PhotoDetailsViewModel] = []
    
    override func renderViewModel(viewModel: PhotoDetailsViewModel) {
        self.receivedViewModels.append(viewModel)
    }
    
}
