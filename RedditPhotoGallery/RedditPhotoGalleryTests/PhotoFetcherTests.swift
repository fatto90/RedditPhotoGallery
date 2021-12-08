//
//  PhotoFetcherTests.swift
//  RedditPhotoGalleryTests
//
//  Created by Matteo Fattori on 08/12/21.
//

import XCTest
@testable import RedditPhotoGallery

class PhotoFetcherTests: XCTestCase {

    var sut: PhotoFetcher!
    
    var urlSessionMock: URLSession!
    var imageCacheMock: ImageCacheMock!
    
    //MARK: Setup
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolMock.self]
        self.urlSessionMock = URLSession(configuration: configuration)
        self.imageCacheMock = ImageCacheMock()
        self.sut = PhotoFetcher(session: self.urlSessionMock, cache: self.imageCacheMock)
        
        
    }
    
    override func tearDown() {
        self.sut = nil
        super.tearDown()
    }
    
    //MARK: getPhotoData tests
    
    func test_getPhotoData_should_fetch_data_from_API_successfully() throws {
        
        //Arrange
        let expectedUrl = URL(string: "https://www.reddit.com/image.png")!
        let expectation = XCTestExpectation(description: "Download image")
        
        let expectedData = Foundation.Data()
        
        // prepare mock request handler to fulfill our URLSession.dataTask request
        URLProtocolMock.requestHandler = { request in
            guard let url = request.url, url == expectedUrl else {
                // here something went wrong
                XCTFail("request Url is not correct: \(String(describing: request.url))")
                throw NSError.init(domain: "tests", code: 0, userInfo: nil)
            }

            let response = HTTPURLResponse(url: expectedUrl, mimeType: "image/png", expectedContentLength: 1, textEncodingName: "png")
            return (response, expectedData)
        }
        
        //Act
        self.sut.fetchPhoto(url: expectedUrl.absoluteString, completionHandler: { data in
            //Assert
            XCTAssertEqual(data, expectedData)
            XCTAssertEqual(expectedUrl.absoluteString, self.imageCacheMock.getFromCacheReceivedUrl)
            XCTAssertEqual(expectedUrl.absoluteString, self.imageCacheMock.storeInCacheReceivedUrl)
            XCTAssertEqual(expectedData, self.imageCacheMock.receivedImageData)
            
            expectation.fulfill()
        })
        
        // wait assertions to fulfill expectations
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_getPhotoData_should_return_cached_data() throws {
        
        //Arrange
        let url = "https://www.reddit.com/image.png"
        let expectedData = Data()
        let expectation = XCTestExpectation(description: "Download image")
        self.imageCacheMock.imageData = expectedData
        
        //Act
        self.sut.fetchPhoto(url: url, completionHandler: { data in
            //Assert
            XCTAssertEqual(data, expectedData)
            XCTAssertEqual(url, self.imageCacheMock.getFromCacheReceivedUrl)
            XCTAssertNil(self.imageCacheMock.storeInCacheReceivedUrl)
            
            expectation.fulfill()
        })
        
        // wait assertions to fulfill expectations
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_getPhotoData_should_return_nil_when_response_is_not_mimeType_image() throws {
        
        //Arrange
        let expectedUrl = URL(string: "https://www.reddit.com/image.png")!
        let expectation = XCTestExpectation(description: "Download image")
        
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
        self.sut.fetchPhoto(url: expectedUrl.absoluteString, completionHandler: { data in
            //Assert
            XCTAssertNil(data)
            
            expectation.fulfill()
        })
        
        // wait assertions to fulfill expectations
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_getPhotoData_should_return_nil_when_url_is_bad() throws {
        
        //Arrange
        let expectation = XCTestExpectation(description: "Download image")
        
        //Act
        self.sut.fetchPhoto(url: "https reddit com image png", completionHandler: { data in
            //Assert
            XCTAssertNil(data)
            
            expectation.fulfill()
        })
        
        // wait assertions to fulfill expectations
        wait(for: [expectation], timeout: 10.0)
    }
    
}
