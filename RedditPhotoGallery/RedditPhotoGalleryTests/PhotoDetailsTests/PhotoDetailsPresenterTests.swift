//
//  PhotoDetailsPresenterTests.swift
//  RedditPhotoGalleryTests
//
//  Created by Matteo Fattori on 08/12/21.
//

import XCTest
@testable import RedditPhotoGallery

class PhotoDetailsPresenterTests: XCTestCase {
    
    var sut: PhotoDetailsPresenter!
    
    var routerMock: PhotoDetailsRouterMock!
    var interactorMock: PhotoDetailsInteractorMock!
    var viewMock: PhotoDetailsViewControllerMock!
    
    let query = "query"
    
    //MARK: Setup
    override func setUp() {
        super.setUp()
        self.routerMock = PhotoDetailsRouterMock()
        self.interactorMock = PhotoDetailsInteractorMock()
        self.viewMock = PhotoDetailsViewControllerMock(presenter: nil)
        self.sut = PhotoDetailsPresenter(router: self.routerMock, interactor: self.interactorMock)
        self.sut.view = self.viewMock
    }
    
    override func tearDown() {
        self.sut = nil
        super.tearDown()
    }
    
    //MARK: getPhotoImage tests
    
    func test_should_return_expected_data() throws {
        //Arrange
        let fakeData = Foundation.Data()
        let fakeUrl = "url"
        self.interactorMock.photoData = fakeData
        let expectation = XCTestExpectation(description: "Download image data")
        
        //Act
        self.sut.getPhotoImage(url: fakeUrl, completion: { data, url in
            //Assert
            XCTAssertEqual(self.interactorMock.receivedUrl, fakeUrl)
            XCTAssertEqual(url, fakeUrl)
            XCTAssertEqual(data, fakeData)
            
            expectation.fulfill()
        })
        
        // wait assertions to fulfill expectations
        wait(for: [expectation], timeout: 10.0)
    }
    
    //MARK: showPhotoDetails tests
    
    func test_should_call_router() throws {
        //Act
        self.sut.goBack()
        
        //Assert
        
        XCTAssertTrue(self.routerMock.dismissCalled)
    }

}
