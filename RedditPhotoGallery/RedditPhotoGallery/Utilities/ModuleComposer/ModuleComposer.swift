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

    private init() {
        self.photoGallery = self.setupPhotoGallery()
    }
    
    private func setupPhotoGallery() -> PhotoGalleryViewController {
        let interactor = PhotoGalleryInteractor()
        let router = PhotoGalleryRouter()
        let presenter = PhotoGalleryPresenter.init(router: router, interactor: interactor)
        let photoGallery = PhotoGalleryViewController.init(presenter: presenter)
        router.view = self.photoGallery
        presenter.view = self.photoGallery
        return photoGallery
    }
}
