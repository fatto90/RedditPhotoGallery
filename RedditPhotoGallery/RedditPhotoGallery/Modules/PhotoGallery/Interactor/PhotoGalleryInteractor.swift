//
//  PhotoGalleryInteractor.swift
//  RedditPhotoGallery
//
//  Created by Matteo Fattori on 04/12/21.
//

import Foundation

class PhotoGalleryInteractor {
    
    private let session: URLSession
    private let cache: PhotoGalleryCache
    private let urlString: String
    private let queryPlaceholder: String

    init(session: URLSession = .shared, cache: PhotoGalleryCache = .shared) {
        self.session = session
        self.cache = cache
        self.queryPlaceholder = "{KEYWORD}"
        self.urlString = "https://www.reddit.com/r/\(self.queryPlaceholder)/top.json"
    }
    
    // MARK: Public members
    
    public func getPhotoGallery(query: String, completionHandler:@escaping (_ data: [ChildrenData]) -> ()) {
        
        // check cache first
        if let cachedResult = self.cache.getFromCache(query: query) {
            completionHandler(cachedResult)
        } else {
            // fetch data from API
            let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            
            if let strongEscapedQuery = escapedQuery,
                let url = URL(string: self.urlString.replacingOccurrences(of: self.queryPlaceholder, with: strongEscapedQuery)) {
                let task = session.dataTask(with: url) {[weak self] data, response, error in
                    if let data = data {
                        let jsonDecoder = JSONDecoder()
                        do {
                            let parsedJSON = try jsonDecoder.decode(RedditPhotoGalleryResponse.self, from: data)
                            
                            self?.handleGetPhotoGalleryResult(query: query, data: parsedJSON, completionHandler: completionHandler)
                        } catch {
                            self?.handleGetPhotoGalleryResult(query: query, data: nil, completionHandler: completionHandler)
                        }
                    } else {
                        self?.handleGetPhotoGalleryResult(query: query, data: nil, completionHandler: completionHandler)
                    }
                }
                task.resume()
            } else {
                self.handleGetPhotoGalleryResult(query: query, data: nil, completionHandler: completionHandler)
            }
        }
    }
    
    public func getPhotoData(url: String, completionHandler:@escaping (_ data: Foundation.Data?) -> ()) {
        PhotoFetcher.fetchPhoto(session: session, url: url, completionHandler: completionHandler)
    }
    
    // MARK: Private members
    
    private func handleGetPhotoGalleryResult(query: String, data: RedditPhotoGalleryResponse?, completionHandler: (_ data: [ChildrenData]) -> ()) {
        var result: [ChildrenData] = []
        if let childrens = data?.data?.children {
            // Here we want only post images
            result = childrens.filter({ children in
                return children.data?.post_hint == "image"
            })
        }
        // cache results
        self.cache.storeInCache(query: query, childrens: result)
        completionHandler(result)
    }
    
}
