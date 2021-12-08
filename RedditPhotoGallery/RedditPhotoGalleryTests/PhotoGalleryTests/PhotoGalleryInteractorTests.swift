//
//  PhotoGalleryInteractorTests.swift
//  RedditPhotoGalleryTests
//
//  Created by Matteo Fattori on 08/12/21.
//

import XCTest
@testable import RedditPhotoGallery

class PhotoGalleryInteractorTests: XCTestCase {

    var sut: PhotoGalleryInteractor!
    
    var urlSessionMock: URLSession!
    var photoGalleryCacheMock: PhotoGalleryCacheMock!
    var photoFetcherMock: PhotoFetcherMock!
    
    let query = "query"
    
    //MARK: Setup
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolMock.self]
        self.urlSessionMock = URLSession(configuration: configuration)
        self.photoGalleryCacheMock = PhotoGalleryCacheMock()
        self.photoFetcherMock = PhotoFetcherMock()
        self.sut = PhotoGalleryInteractor(session: self.urlSessionMock, cache: self.photoGalleryCacheMock, photoFetcher: self.photoFetcherMock)
        
        
    }
    
    override func tearDown() {
        self.sut = nil
        super.tearDown()
    }
    
    //MARK: getPhotoGallery tests
    
    func test_getPhotoGallery_should_hit_cache_successfully() throws {
        
        //Arrange
        let expectation = XCTestExpectation(description: "Download images")
        let expectedData = ChildrensDataBuilder.getFakeChildrens()
        self.photoGalleryCacheMock.childrens = expectedData
        
        //Act
        self.sut.getPhotoGallery(query: self.query, completionHandler: { data in
            //Assert
            XCTAssertEqual(self.photoGalleryCacheMock.getFromCacheReceivedQuery, self.query)
            XCTAssertNil(self.photoGalleryCacheMock.storeInCacheReceivedQuery)
            XCTAssertNil(self.photoGalleryCacheMock.childrensReceived)
            self.assert(expected: expectedData, received: data)
            
            expectation.fulfill()
        })
        
        // wait assertions to fulfill expectations
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_getPhotoGallery_should_fetch_data_from_API_successfully() throws {
        
        //Arrange
        let expectedUrl = URL(string: "https://www.reddit.com/r/\(self.query)/top.json")!
        let expectation = XCTestExpectation(description: "Download images")
        
        let expectedData = Data(children: ChildrensDataBuilder.getFakeChildrens())
        let expectedResponse = RedditPhotoGalleryResponse(data: expectedData, message: nil, error: nil)
        let expectedResponseData = self.encodeJsonFrom(response: expectedResponse)
        
        // prepare mock request handler to fulfill our URLSession.dataTask request
        URLProtocolMock.requestHandler = { request in
            guard let url = request.url, url == expectedUrl else {
                // here something went wrong
                XCTFail("request Url is not correct: \(String(describing: request.url))")
                throw NSError.init(domain: "tests", code: 0, userInfo: nil)
            }

            let response = HTTPURLResponse(url: expectedUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, expectedResponseData)
        }
        
        //Act
        self.sut.getPhotoGallery(query: self.query, completionHandler: { data in
            //Assert
            XCTAssertEqual(self.photoGalleryCacheMock.getFromCacheReceivedQuery, self.query)
            XCTAssertEqual(self.photoGalleryCacheMock.storeInCacheReceivedQuery, self.query)
            self.assert(expected: expectedData.children!, received: self.photoGalleryCacheMock.childrensReceived!)
            self.assert(expected: expectedData.children!, received: data)
            
            expectation.fulfill()
        })
        
        // wait assertions to fulfill expectations
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_getPhotoGallery_should_return_empty_childrens_on_missing_data() throws {
        
        //Arrange
        let expectedUrl = URL(string: "https://www.reddit.com/r/\(self.query)/top.json")!
        let expectation = XCTestExpectation(description: "Download images")
        
        // prepare mock request handler to fulfill our URLSession.dataTask request
        URLProtocolMock.requestHandler = { request in
            guard let url = request.url, url == expectedUrl else {
                // here something went wrong
                XCTFail("request Url is not correct: \(String(describing: request.url))")
                throw NSError.init(domain: "tests", code: 0, userInfo: nil)
            }

            let response = HTTPURLResponse(url: expectedUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }
        
        //Act
        self.sut.getPhotoGallery(query: self.query, completionHandler: { data in
            //Assert
            XCTAssertEqual(self.photoGalleryCacheMock.getFromCacheReceivedQuery, self.query)
            XCTAssertEqual(self.photoGalleryCacheMock.storeInCacheReceivedQuery, self.query)
            XCTAssertEqual(self.photoGalleryCacheMock.childrensReceived?.count, 0)
            XCTAssertEqual(data.count, 0)
            
            expectation.fulfill()
        })
        
        // wait assertions to fulfill expectations
        wait(for: [expectation], timeout: 10.0)
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
