//
//  UserDefaultsMock.swift
//  RedditPhotoGalleryTests
//
//  Created by Matteo Fattori on 08/12/21.
//

import Foundation

class UserDefaultsMock: UserDefaults {
    
    var receivedObjectKey: String?
    var receivedSetKey: String?
    var receivedValue: Any?
    var object: Any?
    
    override func object(forKey defaultName: String) -> Any? {
        self.receivedObjectKey = defaultName
        return self.object
    }
    
    override func set(_ value: Any?, forKey defaultName: String) {
        self.receivedSetKey = defaultName
        self.receivedValue = value
    }
    
}
