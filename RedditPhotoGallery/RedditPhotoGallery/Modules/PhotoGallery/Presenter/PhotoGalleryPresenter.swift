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
    
    weak var view: UIViewController?
    
    init(router: PhotoGalleryRouter, interactor: PhotoGalleryInteractor) {
        self.interactor = interactor
        self.router = router
    }
}
