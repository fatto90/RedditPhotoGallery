//
//  PhotoDetailsInteractorTests.swift
//  RedditPhotoGalleryTests
//
//  Created by Matteo Fattori on 08/12/21.
//

import XCTest
@testable import RedditPhotoGallery

class PhotoDetailsInteractorTests: XCTestCase {

    var sut: PhotoDetailsInteractor!
    
    var photoFetcherMock: PhotoFetcherMock!
    
    let query = "query"
    
    //MARK: Setup
    override func setUp() {
        super.setUp()
        self.photoFetcherMock = PhotoFetcherMock()
        self.sut = PhotoDetailsInteractor(photoFetcher: self.photoFetcherMock)
        
        
    }
    
    override func tearDown() {
        self.sut = nil
        super.tearDown()
    }
    
    //MARK: getPhotoData tests
    
    func test_getPhotoData_should_return_expected_data() throws {
        
        //Arrange
        let expectedUrl = URL(string: "https://www.reddit.com/image.png")!
        let expectedData = Foundation.Data()
        let expectation = XCTestExpectation(description: "Download images")
        self.photoFetcherMock.photoData = expectedData
        
        //Act
        self.sut.getPhotoData(url: expectedUrl.absoluteString, completionHandler: { data in
            //Assert
            XCTAssertEqual(self.photoFetcherMock.receivedUrl, expectedUrl.absoluteString)
            XCTAssertEqual(data, expectedData)
            
            expectation.fulfill()
        })
        
        // wait assertions to fulfill expectations
        wait(for: [expectation], timeout: 10.0)
    }
    
    //MARK: Private members
    
    private func encodeJsonFrom(response: RedditPhotoGalleryResponse) -> Foundation.Data? {
        do {
            let data = try JSONEncoder().encode(response)
            return data
        } catch {
            print("Unable to Encode (\(error))")
        }
        return nil
    }
    
    private func assert(expected: [ChildrenData], received: [ChildrenData]) {
        XCTAssertEqual(expected.count, received.count)
        for index in 0...(received.count-1) {
            let childrenExpected = expected[index]
            let childrenReceived = received[index]
            XCTAssertEqual(childrenExpected.data?.thumbnail, childrenReceived.data?.thumbnail)
            XCTAssertEqual(childrenExpected.data?.url, childrenReceived.data?.url)
            XCTAssertEqual(childrenExpected.data?.title, childrenReceived.data?.title)
            XCTAssertEqual(childrenExpected.data?.author_fullname, childrenReceived.data?.author_fullname)
        }
    }
    
}
