//
//  PhotoDetailsInteractor.swift
//  RedditPhotoGallery
//
//  Created by Matteo Fattori on 05/12/21.
//

import Foundation

class PhotoDetailsInteractor {
    
    private let photoFetcher: PhotoFetcher

    init(photoFetcher: PhotoFetcher = .shared) {
        self.photoFetcher = photoFetcher
    }
    
    public func getPhotoData(url: String, completionHandler:@escaping (_ data: Foundation.Data?) -> ()) {
        self.photoFetcher.fetchPhoto(url: url, completionHandler: completionHandler)
    }
    
}
