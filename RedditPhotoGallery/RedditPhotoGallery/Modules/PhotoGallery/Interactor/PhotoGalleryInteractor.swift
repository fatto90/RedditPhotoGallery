//
//  PhotoGalleryInteractor.swift
//  RedditPhotoGallery
//
//  Created by Matteo Fattori on 04/12/21.
//

import Foundation

class PhotoGalleryInteractor {
    
    private let session: URLSession
    private let urlString: String
    private let queryPlaceholder: String

    init(session: URLSession = .shared) {
        self.session = session
        self.queryPlaceholder = "{KEYWORD}"
        self.urlString = "https://www.reddit.com/r/\(self.queryPlaceholder)/top.json"
    }
    
    // MARK: Public members
    
    public func getPhotoGallery(query: String, completionHandler:@escaping (_ data: [ChildrenData], _ error: Bool) -> ()) {
        let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        if let strongEscapedQuery = escapedQuery,
            let url = URL(string: self.urlString.replacingOccurrences(of: self.queryPlaceholder, with: strongEscapedQuery)) {
            let task = session.dataTask(with: url) {[weak self] data, response, error in
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let parsedJSON = try jsonDecoder.decode(RedditPhotoGalleryResponse.self, from: data)
                        
                        self?.handleGetPhotoGalleryResult(data: parsedJSON, completionHandler: completionHandler)
                    } catch {
                        self?.handleGetPhotoGalleryResult(data: nil, completionHandler: completionHandler)
                    }
                } else {
                    self?.handleGetPhotoGalleryResult(data: nil, completionHandler: completionHandler)
                }
            }
            task.resume()
        } else {
            self.handleGetPhotoGalleryResult(data: nil, completionHandler: completionHandler)
        }
    }
    
    public func getPhotoData(url: String, completionHandler:@escaping (_ data: Foundation.Data?) -> ()) {
        if let url = URL(string: url) {
            let task = session.dataTask(with: url) { data, response, error in
                // check if response is an image
                if let mimeType = response?.mimeType, mimeType.hasPrefix("image"), let data = data {
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
    
    // MARK: Private members
    
    private func handleGetPhotoGalleryResult(data: RedditPhotoGalleryResponse?, completionHandler: (_ data: [ChildrenData], _ error: Bool) -> ()) {
        var error: Bool = true
        var result: [ChildrenData] = []
        if let childrens = data?.data?.children {
            error = false
            result = childrens
        }
        completionHandler(result, error)
    }
    
}
