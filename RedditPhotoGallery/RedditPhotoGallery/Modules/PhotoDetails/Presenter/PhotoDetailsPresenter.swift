//
//  PhotoDetailsPresenter.swift
//  RedditPhotoGallery
//
//  Created by Matteo Fattori on 05/12/21.
//

import Foundation

class PhotoDetailsPresenter {
    
    var interactor: PhotoDetailsInteractor
    var router: PhotoDetailsRouter
    
    var images: [PhotoImageViewModel]?
    var startIndex: Int?
    
    weak var view: PhotoDetailsViewController?
    
    init(router: PhotoDetailsRouter, interactor: PhotoDetailsInteractor) {
        self.interactor = interactor
        self.router = router
    }
}
