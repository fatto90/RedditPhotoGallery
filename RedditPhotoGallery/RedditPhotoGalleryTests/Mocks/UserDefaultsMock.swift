//
//  UserDefaultsMock.swift
//  RedditPhotoGalleryTests
//
//  Created by Matteo Fattori on 08/12/21.
//

import Foundation

class UserDefaultsMock: UserDefaults {
    
    var receivedObjectKeys: [String] = []
    var receivedSetKeys: [String] = []
    var receivedValues: [Any?] = []
    var objects: [Any?] = []
    
    override func object(forKey defaultName: String) -> Any? {
        self.receivedObjectKeys.append(defaultName)
        // objects list used like a FIFO queue.
        var resultObject: Any? = nil
        if !self.objects.isEmpty {
            resultObject = self.objects.first!
            self.objects.removeFirst()
        }
        return resultObject
    }
    
    override func set(_ value: Any?, forKey defaultName: String) {
        self.receivedSetKeys.append(defaultName)
        self.receivedValues.append(value)
    }
    
}
