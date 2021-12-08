//
//  PhotoFetcher.swift
//  RedditPhotoGallery
//
//  Created by Matteo Fattori on 06/12/21.
//

import Foundation

class PhotoFetcher {
    
    // MARK: Properties
    
    static let shared = PhotoFetcher()

    private let session: URLSession
    private let cache: ImageCache
    
    init(session: URLSession = .shared, cache: ImageCache = .shared) {
        self.session = session
        self.cache = cache
    }
    
    // MARK: Public members
    
    public func fetchPhoto(url: String, completionHandler:@escaping (_ data: Foundation.Data?) -> ()) {
        if let cachedImageData = self.cache.getFromCache(url: url) {
            completionHandler(cachedImageData)
        } else {
            if let urlObject = URL(string: url) {
                let task = self.session.dataTask(with: urlObject) { data, response, error in
                    // check if response is an image
                    if let mimeType = response?.mimeType, mimeType.hasPrefix("image"), let data = data {
                        self.cache.storeInCache(url: url, imageData: data)
                        completionHandler(data)
                    } else {
                        completionHandler(nil)
                    }
                }
                task.resume()
            } else {
                completionHandler(nil)
            }
        }
    }
    
}
