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
    
    //MARK: getFromCache tests
    
    func test_getFromCache_should_return_expected_data() throws {
        //Arrange
        let expectedKey = "123"
        let expectedData = Foundation.Data()
        self.userDefaultsMock.objects = [expectedData]
        
        //Act
        let result = self.sut.getFromCache(url: expectedKey)
        
        //Assert
        XCTAssertEqual(result, expectedData)
        XCTAssertEqual(self.userDefaultsMock.receivedObjectKeys[0], expectedKey)
    }
    
    func test_getFromCache_should_return_nil() throws {
        //Arrange
        let expectedKey = "123"
        
        //Act
        let result = self.sut.getFromCache(url: expectedKey)
        
        //Assert
        XCTAssertNil(result)
        XCTAssertEqual(self.userDefaultsMock.receivedObjectKeys[0], expectedKey)
    }
    
    //MARK: storeInCache tests
    
    func test_storeInCache_should_store_data_properly() throws {
        //Arrange
        let expectedKey = "123"
        let expectedData = Foundation.Data()
        
        //Act
        self.sut.storeInCache(url: expectedKey, imageData: expectedData)
        
        //Assert
        XCTAssertEqual(self.userDefaultsMock.receivedSetKeys[0], expectedKey)
        XCTAssertEqual(self.userDefaultsMock.receivedValues[0] as? Foundation.Data, expectedData)
    }
    
}
