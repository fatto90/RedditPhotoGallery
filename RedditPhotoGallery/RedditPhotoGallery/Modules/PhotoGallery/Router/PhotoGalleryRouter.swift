//
//  TodoListRouter.swift
//  RedditPhotoGallery
//
//  Created by Matteo Fattori on 04/12/21.
//

import Foundation
import UIKit

class PhotoGalleryRouter {
    
    weak var view: UIViewController?
    
    public func showPhotoDetails(images: [PhotoImageViewModel], index: Int) {
        ModuleComposer.shared.photoDetails.presenter?.images = images
        ModuleComposer.shared.photoDetails.presenter?.startIndex = index
        self.view?.navigationController?.pushViewController(ModuleComposer.shared.photoDetails, animated: true)
    }
    
}
