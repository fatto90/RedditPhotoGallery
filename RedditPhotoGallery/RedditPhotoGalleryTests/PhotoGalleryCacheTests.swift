//
//  PhotoGalleryCacheTests.swift
//  RedditPhotoGalleryTests
//
//  Created by Matteo Fattori on 08/12/21.
//

import XCTest
@testable import RedditPhotoGallery

class RedditPhotoGalleryTests: XCTestCase {

    var sut: PhotoGalleryCache!
    
    var userDefaultsMock: UserDefaultsMock!
    let query = "query"
    let childrensCacheKey = "childrensCacheKey"
    
    //MARK: Setup
    override func setUp() {
        super.setUp()
        self.userDefaultsMock = UserDefaultsMock()
        self.sut = PhotoGalleryCache(userDefaults: self.userDefaultsMock)
    }
    
    override func tearDown() {
        self.sut = nil
        super.tearDown()
    }
    
    //MARK: getFromCache tests
    
    func test_getFromCache_should_return_nil_when_children_ids_are_not_stored() throws {
        //Act
        let result = self.sut.getFromCache(query: query)
        
        //Assert
        XCTAssertNil(result)
        XCTAssertEqual(self.userDefaultsMock.receivedObjectKeys.first, query)
    }
    
    func test_getFromCache_should_return_nil_when_children_ids_are_stored_and_childrens_dont() throws {
        //Arrange
        let childrenIds = ["1", "2", "3"]
        let cachedChildrens = CachedChildrens()
        cachedChildrens.childrens = ChildrensDataBuilder.getFakeChildrens()
        
        self.userDefaultsMock.objects = [childrenIds, self.encodeJsonFrom(cachedChildrens:cachedChildrens)]
        
        //Act
        let result = self.sut.getFromCache(query: query)
        
        //Assert
        XCTAssertNil(result)
        XCTAssertEqual(self.userDefaultsMock.receivedObjectKeys[0], query)
        XCTAssertEqual(self.userDefaultsMock.receivedObjectKeys[1], self.childrensCacheKey)
    }
    
    func test_getFromCache_should_return_data_when_children_ids_and_childrens_are_stored() throws {
        //Arrange
        let childrenIds = ["id1"]
        let cachedChildrens = CachedChildrens()
        cachedChildrens.childrens = ChildrensDataBuilder.getFakeChildrens()
        
        self.userDefaultsMock.objects = [childrenIds, self.encodeJsonFrom(cachedChildrens:cachedChildrens)]
        
        //Act
        let result = self.sut.getFromCache(query: query)
        
        //Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.count, 1)
        XCTAssertEqual(result![0].data?.id, childrenIds[0])
        XCTAssertEqual(self.userDefaultsMock.receivedObjectKeys[0], query)
        XCTAssertEqual(self.userDefaultsMock.receivedObjectKeys[1], self.childrensCacheKey)
    }
    
    //MARK: storeInCache tests
    
    func test_storeInCache_should_not_store_when_childrens_empty() throws {
        
        //Act
        self.sut.storeInCache(query: query, childrens: [])
        
        //Assert
        XCTAssertEqual(self.userDefaultsMock.receivedObjectKeys.count, 0)
        XCTAssertEqual(self.userDefaultsMock.receivedSetKeys.count, 0)
    }
    
    func test_storeInCache_should_store_childrens_and_ids() throws {
        //Arrange
        let childrens = ChildrensDataBuilder.getFakeChildrens()
        let childrenToAdd = ChildrensDataBuilder.getFakeChildren()
        let cachedChildrens = CachedChildrens()
        cachedChildrens.childrens = childrens
        
        let expectedChildrens = CachedChildrens()
        expectedChildrens.childrens = [childrenToAdd]
        expectedChildrens.childrens?.append(contentsOf: childrens)
        let expectedChildrensData = self.encodeJsonFrom(cachedChildrens:expectedChildrens)
        
        self.userDefaultsMock.objects = [self.encodeJsonFrom(cachedChildrens:cachedChildrens)]
        
        //Act
        self.sut.storeInCache(query: query, childrens: [childrenToAdd])
        
        //Assert
        XCTAssertEqual(self.userDefaultsMock.receivedSetKeys[0], self.query)
        let receivedChildrenIds = self.userDefaultsMock.receivedValues[0] as! [String]
        XCTAssertEqual(receivedChildrenIds, [childrenToAdd.data!.id])
        XCTAssertEqual(self.userDefaultsMock.receivedObjectKeys[0], self.childrensCacheKey)
        XCTAssertEqual(self.userDefaultsMock.receivedSetKeys[1], self.childrensCacheKey)
        
        let storedChildrensData = self.userDefaultsMock.receivedValues[1] as! Foundation.Data
        XCTAssertEqual(storedChildrensData, expectedChildrensData)
    }
    
    //MARK: Private members
    
    private func encodeJsonFrom(cachedChildrens: CachedChildrens) -> Foundation.Data? {
        do {
            let data = try JSONEncoder().encode(cachedChildrens)
            return data
        } catch {
            print("Unable to Encode (\(error))")
        }
        return nil
    }
    
}
