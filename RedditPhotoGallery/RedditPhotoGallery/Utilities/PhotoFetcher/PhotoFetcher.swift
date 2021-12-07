//
//  PhotoFetcher.swift
//  RedditPhotoGallery
//
//  Created by Matteo Fattori on 06/12/21.
//

import Foundation

class PhotoFetcher {
    
    public static func fetchPhoto(session: URLSession, url: String, completionHandler:@escaping (_ data: Foundation.Data?) -> ()) {
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
    
}
