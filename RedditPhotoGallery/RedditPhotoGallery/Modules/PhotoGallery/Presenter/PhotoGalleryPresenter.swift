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
        // set view to loading state
        let viewModel = self.getPhotoGalleryViewModel(query: query, childrens: [], loading: true)
        self.view?.renderViewModel(viewModel: viewModel)
        
        // cancel previous search request
        self.currentDataFetchWorkItem?.cancel()
        
        // create the new search request
        self.currentDataFetchWorkItem = DispatchWorkItem(block: {
            self.getPhotoGalleryData(query: query, workItem: self.currentDataFetchWorkItem!)
        })
        // launch the search request in a background thread using a sequencial Queue
        DispatchQueue(label: "serial.queue").async(execute: self.currentDataFetchWorkItem!)
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
    
    public func showPhotoDetails(images: [PhotoImageViewModel]?, index: Int) {
        if let strongImages = images {
            self.router.showPhotoDetails(images: strongImages, index: index)
        }
    }
    
    // MARK: Private members
    
    private func getPhotoGalleryData(query: String, workItem: DispatchWorkItem) {
        // fetch data from interactor
        self.interactor.getPhotoGallery(query: query) {[weak self] childrens in
            // generate viewModel from data result, empty if something went wrong
            let viewModel = self?.getPhotoGalleryViewModel(query: query, childrens: childrens, loading: false)
            DispatchQueue.main.async {
                // Update gallery if this the last search
                if workItem.isCancelled {
                    return
                }
                if let strongViewModel = viewModel {
                    self?.view?.renderViewModel(viewModel: strongViewModel)
                }
            }
        }
    }
    
    private func getPhotoGalleryViewModel(query: String, childrens: [ChildrenData], loading: Bool) -> PhotoGalleryViewModel {
        let viewModel = PhotoGalleryViewModel()
        
        var imageViewModels = [PhotoImageViewModel]()
        for children in childrens {
            // check if reddit post is an image
            if children.data?.post_hint == "image" {
                let imageViewModel = PhotoImageViewModel()
                imageViewModel.title = children.data?.title
                imageViewModel.imageUrl = children.data?.url
                imageViewModel.thumbnailUrl = children.data?.thumbnail
                imageViewModel.author = children.data?.author_fullname
                imageViewModels.append(imageViewModel)
            }
        }
        viewModel.showExtraInfo = query.isEmpty || imageViewModels.isEmpty || loading
        viewModel.extraInfoText = self.getExtraInfoTextFor(query: query, imageViewModels: imageViewModels, loading: loading)
        viewModel.extraInfoIcon = self.getExtraInfoIconFor(query: query, imageViewModels: imageViewModels, loading: loading)
        
        viewModel.images = imageViewModels
        
        return viewModel
    }
    
    private func getExtraInfoTextFor(query: String, imageViewModels: [PhotoImageViewModel], loading: Bool) -> String? {
        if loading {
            return "Searching..."
        }
        if query.isEmpty {
            return "Please write something..."
        }
        if imageViewModels.isEmpty {
            return "No Result Found"
        }
        return nil
    }
    
    private func getExtraInfoIconFor(query: String, imageViewModels: [PhotoImageViewModel], loading: Bool) -> UIImage? {
        if loading {
            return nil
        }
        if query.isEmpty {
            return UIImage(systemName: "hand.point.up.left.fill")
        }
        if imageViewModels.isEmpty {
            return UIImage(systemName: "eyes")
        }
        return nil
    }
    
}
