//
//  RedditPhotoGalleryResponse.swift
//  RedditPhotoGallery
//
//  Created by Matteo Fattori on 05/12/21.
//

import Foundation

struct RedditPhotoGalleryResponse: Codable {
    let data: Data?
    let message: String?
    let error: Int?
}

struct Data: Codable {
    let children: [ChildrenData]?
}

struct ChildrenData: Codable {
    let data: ImageData?
}

struct ImageData: Codable {
    let id: String?
    let title: String?
    let post_hint: String?
    let thumbnail: String?
    let url: String?
    let author_fullname: String?
}
