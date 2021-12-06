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
    
    private var isPresented = false
    
    init(router: PhotoDetailsRouter, interactor: PhotoDetailsInteractor) {
        self.interactor = interactor
        self.router = router
    }
    
    //MARK: Public members
    
    public func getPhotoImage(url: String?, completion:@escaping (_ data: Foundation.Data?, _ url: String?) -> ()) {
        if let strongUrl = url {
            // fetch the image data in a background thread
            DispatchQueue.global().async {
                self.interactor.getPhotoData(url: strongUrl) { data in
                    DispatchQueue.main.async {
                        completion(data, url)
                    }
                }
            }
        } else {
            completion(nil, url)
        }
    }
    
    public func goBack() {
        self.isPresented = false
        self.router.dismissModule()
    }
    
    public func update(startIndex: Int) {
        self.startIndex = startIndex
    }
    
    public func refreshOneTimePhotoDetails() {
        if !self.isPresented {
            self.isPresented = true
            self.refreshPhotoDetails()
        }
    }
    
    public func refreshPhotoDetails() {
        let viewModel = PhotoDetailsViewModel()
        viewModel.images = self.images
        viewModel.startIndex = self.startIndex
        
        self.view?.renderViewModel(viewModel: viewModel)
    }
    
}
