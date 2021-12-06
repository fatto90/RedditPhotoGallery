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
    
    //MARK: Public members
    
    public func goBack() {
        self.router.dismissModule()
    }
    
    public func refreshPhotoDetails() {
        let viewModel = PhotoDetailsViewModel()
        viewModel.images = self.images
        viewModel.startIndex = self.startIndex
        
        self.view?.renderViewModel(viewModel: viewModel)
    }
    
}
