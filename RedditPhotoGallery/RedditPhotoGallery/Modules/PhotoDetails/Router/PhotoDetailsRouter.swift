//
//  PhotoDetailsRouter.swift
//  RedditPhotoGallery
//
//  Created by Matteo Fattori on 05/12/21.
//

import Foundation
import UIKit

class PhotoDetailsRouter {
    
    weak var view: UIViewController?
    
    public func dismissModule() {
        self.view?.navigationController?.popViewController(animated: true)
    }
}
