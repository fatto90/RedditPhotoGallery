//
//  PhotoDetailsInteractor.swift
//  RedditPhotoGallery
//
//  Created by Matteo Fattori on 05/12/21.
//

import Foundation

class PhotoDetailsInteractor {
    
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func getPhotoData(url: String, completionHandler:@escaping (_ data: Foundation.Data?) -> ()) {
        PhotoFetcher.fetchPhoto(session: session, url: url, completionHandler: completionHandler)
    }
    
}
