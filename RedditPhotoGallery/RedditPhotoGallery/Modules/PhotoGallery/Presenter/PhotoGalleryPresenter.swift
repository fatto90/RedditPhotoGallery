//
//  PhotoGalleryPresenter.swift
//  RedditPhotoGallery
//
//  Created by Matteo Fattori on 04/12/21.
//

import Foundation
import UIKit

class PhotoGalleryPresenter {
    
    var interactor: PhotoGalleryInteractor
    var router: PhotoGalleryRouter
    
    weak var view: PhotoGalleryViewController?
    
    private var currentDataFetchWorkItem: DispatchWorkItem?
    
    init(router: PhotoGalleryRouter, interactor: PhotoGalleryInteractor) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: Public members
    
    public func refreshPhotoGallery(query: String) {
        
        // cancel previous search request
        self.currentDataFetchWorkItem?.cancel()
        
        // create the new search request
        self.currentDataFetchWorkItem = DispatchWorkItem(block: {
            self.getPhotoGalleryData(query: query)
        })
        // launch the search request in a background thread
        DispatchQueue.global().async(execute: self.currentDataFetchWorkItem!)
        
    }
    
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
    
    // MARK: Private members
    
    private func getPhotoGalleryData(query: String) {
        // fetch data from interactor
        self.interactor.getPhotoGallery(query: query) {[weak self] childrens, error in
            // generate viewModel from data result, empty if something went wrong
            let viewModel = self?.getPhotoGalleryViewModel(childrens: childrens)
            DispatchQueue.main.async {
                if error {
                    //notify user that something went wrong
                    self?.view?.renderError()
                }
                // Update gallery
                if let strongViewModel = viewModel {
                    self?.view?.renderViewModel(viewModel: strongViewModel)
                }
            }
        }
    }
    
    private func getPhotoGalleryViewModel(childrens: [ChildrenData]) -> PhotoGalleryViewModel {
        let viewModel = PhotoGalleryViewModel()
        
        var imageViewModels = [PhotoImageViewModel]()
        for children in childrens {
            let imageViewModel = PhotoImageViewModel()
            imageViewModel.title = children.data?.title
            imageViewModel.imageUrl = self.tryGetImageUrlFrom(children: children)
            imageViewModel.htmlDescription = children.data?.description_html
            imageViewModels.append(imageViewModel)
        }
        
        viewModel.images = imageViewModels
        
        return viewModel
    }
    
    private func tryGetImageUrlFrom(children: ChildrenData?) -> String? {
        // check if the post is "image" itself
        if children?.data?.post_hint == "image", let imageUrl = children?.data?.url {
            return imageUrl
        }
        // try get the post thumbnail
        if let thubnailUrl = children?.data?.thumbnail {
            return thubnailUrl
        }
        // header image otherwise..
        return children?.data?.header_img
    }
    
}
