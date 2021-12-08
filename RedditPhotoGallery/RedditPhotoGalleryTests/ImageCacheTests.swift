//
//  ImageCacheTests.swift
//  RedditPhotoGalleryTests
//
//  Created by Matteo Fattori on 08/12/21.
//

import XCTest
@testable import RedditPhotoGallery

class ImageCacheTests: XCTestCase {

    var sut: ImageCache!
    
    var userDefaultsMock: UserDefaultsMock!
    
    //MARK: Setup
    override func setUp() {
        super.setUp()
        self.userDefaultsMock = UserDefaultsMock()
        self.sut = ImageCache(userDefaults: self.userDefaultsMock)
    }
    
    override func tearDown() {
        self.sut = nil
        super.tearDown()
    }
    
    //MARK: getPhotoData tests
    
    func test_getFromCache_should_return_expected_data() throws {
        //Arrange
        let expectedKey = "123"
        let expectedData = Foundation.Data()
        self.userDefaultsMock.object = expectedData
        
        //Act
        let result = self.sut.getFromCache(url: expectedKey)
        
        //Assert
        XCTAssertEqual(result, expectedData)
        XCTAssertEqual(self.userDefaultsMock.receivedObjectKey, expectedKey)
    }
    
    func test_getFromCache_should_return_nil() throws {
        //Arrange
        let expectedKey = "123"
        
        //Act
        let result = self.sut.getFromCache(url: expectedKey)
        
        //Assert
        XCTAssertNil(result)
        XCTAssertEqual(self.userDefaultsMock.receivedObjectKey, expectedKey)
    }
    
    //MARK: storeInCache tests
    
    func test_storeInCache_should_store_data_properly() throws {
        //Arrange
        let expectedKey = "123"
        let expectedData = Foundation.Data()
        
        //Act
        self.sut.storeInCache(url: expectedKey, imageData: expectedData)
        
        //Assert
        XCTAssertEqual(self.userDefaultsMock.receivedSetKey, expectedKey)
        XCTAssertEqual(self.userDefaultsMock.receivedValue as? Foundation.Data, expectedData)
    }
    
}
