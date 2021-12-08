//
//  ChildrensDataBuilder.swift
//  RedditPhotoGalleryTests
//
//  Created by Matteo Fattori on 08/12/21.
//

import Foundation
@testable import RedditPhotoGallery

class ChildrensDataBuilder {
    
    public static func getFakeChildrens() -> [ChildrenData] {
        var childrens: [ChildrenData] = []
        
        let firstImageData = ImageData(id: "id1",
                                       title: "first image",
                                       post_hint: "image",
                                       thumbnail: "firstThumbnailUrl",
                                       url: "firstImageUrl",
                                       author_fullname: "first image author")
        
        let firstChildren = ChildrenData(data: firstImageData)
        childrens.append(firstChildren)
        
        let secondImageData = ImageData(id: "id2",
                                       title: "second image",
                                       post_hint: "image",
                                       thumbnail: "secondThumbnailUrl",
                                       url: "secondImageUrl",
                                       author_fullname: "second image author")
        
        let secondChildren = ChildrenData(data: secondImageData)
        childrens.append(secondChildren)
        return childrens
    }
    
    public static func getFakeChildren() -> ChildrenData {
        let imageData = ImageData(id: "id3",
                                   title: "third image",
                                   post_hint: "image",
                                   thumbnail: "thirdThumbnailUrl",
                                   url: "thirdImageUrl",
                                   author_fullname: "third image author")
        
        let children = ChildrenData(data: imageData)
        return children
    }
    
}
