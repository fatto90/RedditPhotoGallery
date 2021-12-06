//
//  ModuleComposer.swift
//  RedditPhotoGallery
//
//  Created by Matteo Fattori on 04/12/21.
//

import Foundation
import UIKit

class ModuleComposer {

    // MARK: Properties
    
    static let shared = ModuleComposer()

    // MARK: Modules

    var photoGallery: PhotoGalleryViewController!
    var photoDetails: PhotoDetailsViewController!

    private init() {
        self.photoGallery = self.setupPhotoGallery()
        self.photoDetails = self.setupPhotoDetails()
    }
    
    private func setupPhotoGallery() -> PhotoGalleryViewController {
        let interactor = PhotoGalleryInteractor()
        let router = PhotoGalleryRouter()
        let presenter = PhotoGalleryPresenter(router: router, interactor: interactor)
        let photoGallery = PhotoGalleryViewController(presenter: presenter)
        router.view = photoGallery
        presenter.view = photoGallery
        return photoGallery
    }
    
    private func setupPhotoDetails() -> PhotoDetailsViewController {
        let interactor = PhotoDetailsInteractor()
        let router = PhotoDetailsRouter()
        let presenter = PhotoDetailsPresenter(router: router, interactor: interactor)
        let photoDetails = PhotoDetailsViewController(presenter: presenter)
        router.view = photoDetails
        presenter.view = photoDetails
        return photoDetails
    }
}
