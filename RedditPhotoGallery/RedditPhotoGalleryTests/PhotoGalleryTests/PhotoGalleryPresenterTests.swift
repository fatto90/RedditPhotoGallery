//
//  PhotoGalleryPresenterTests.swift
//  RedditPhotoGalleryTests
//
//  Created by Matteo Fattori on 08/12/21.
//

import XCTest
@testable import RedditPhotoGallery

class PhotoGalleryPresenterTests: XCTestCase {
    
    var sut: PhotoGalleryPresenter!
    
    var routerMock: PhotoGalleryRouterMock!
    var interactorMock: PhotoGalleryInteractorMock!
    var viewMock: PhotoGalleryViewControllerMock!
    
    let query = "query"
    
    //MARK: Setup
    override func setUp() {
        super.setUp()
        self.routerMock = PhotoGalleryRouterMock()
        self.interactorMock = PhotoGalleryInteractorMock()
        self.viewMock = PhotoGalleryViewControllerMock(presenter: nil)
        self.sut = PhotoGalleryPresenter(router: self.routerMock, interactor: self.interactorMock)
        self.sut.view = self.viewMock
    }
    
    override func tearDown() {
        self.sut = nil
        super.tearDown()
    }
    
    //MARK: refreshPhotoGallery tests
    
    func test_should_build_empty_images() throws {
        //Arrange
        self.interactorMock.childrensData = []
        let expectation = XCTestExpectation(description: "Download images")
        
        //Act
        self.sut.refreshPhotoGallery(query: self.query) {
            //Assert
            XCTAssertEqual(self.interactorMock.receivedQuery, self.query)
            XCTAssertEqual(self.viewMock.receivedViewModels.count, 2)
            let loadingViewModel = self.viewMock.receivedViewModels[0]
            self.assert(loadingViewModel: loadingViewModel)
            
            let resultViewModel = self.viewMock.receivedViewModels[1]
            XCTAssertEqual(resultViewModel.images?.count, 0)
            XCTAssertEqual(resultViewModel.extraInfoText, "No Result Found")
            XCTAssertNotNil(resultViewModel.extraInfoIcon)
            XCTAssertTrue(resultViewModel.showExtraInfo ?? false)
            
            expectation.fulfill()
        }
        
        // wait assertions to fulfill expectations
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_should_build_images_from_data() throws {
        //Arrange
        let fakeData = self.getFakeChildrens()
        self.interactorMock.childrensData = fakeData
        let expectation = XCTestExpectation(description: "Download images")
        
        //Act
        self.sut.refreshPhotoGallery(query: self.query) {
            //Assert
            XCTAssertEqual(self.interactorMock.receivedQuery, self.query)
            XCTAssertEqual(self.viewMock.receivedViewModels.count, 2)
            let loadingViewModel = self.viewMock.receivedViewModels[0]
            self.assert(loadingViewModel: loadingViewModel)
            
            let resultViewModel = self.viewMock.receivedViewModels[1]
            self.assert(images: resultViewModel.images!, data: fakeData)
            XCTAssertNil(resultViewModel.extraInfoText)
            XCTAssertNil(resultViewModel.extraInfoIcon)
            XCTAssertFalse(resultViewModel.showExtraInfo ?? false)
            
            expectation.fulfill()
        }
        
        // wait assertions to fulfill expectations
        wait(for: [expectation], timeout: 10.0)
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
    
    func test_should_call_router_with_empty_images() throws {
        //Act
        self.sut.showPhotoDetails(images: [], index: 1)
        
        //Assert
        XCTAssertEqual(self.routerMock.receivedImages?.count, 0)
    }
    
    func test_should_call_router() throws {
        //Arrange
        var fakeImages: [PhotoImageViewModel] = []
        let fakePhoto = PhotoImageViewModel()
        fakePhoto.imageUrl = "imageUrl"
        fakeImages.append(fakePhoto)
        let fakeIndex = 1
        
        //Act
        self.sut.showPhotoDetails(images: fakeImages, index: fakeIndex)
        
        //Assert
        
        XCTAssertEqual(self.routerMock.receivedImages?.count, fakeImages.count)
        let resultPhoto = self.routerMock.receivedImages![0]
        XCTAssertEqual(resultPhoto.imageUrl, fakePhoto.imageUrl)
        XCTAssertEqual(self.routerMock.receivedIndex, fakeIndex)
    }
    
    func test_should_not_call_router() throws {
        //Act
        self.sut.showPhotoDetails(images: nil, index: 1)
        
        //Assert
        XCTAssertNil(self.routerMock.receivedImages)
    }
    
    //MARK: Private members
    
    private func assert(loadingViewModel: PhotoGalleryViewModel) {
        XCTAssertEqual(loadingViewModel.images?.count, 0)
        XCTAssertEqual(loadingViewModel.extraInfoText, "Searching...")
        XCTAssertNil(loadingViewModel.extraInfoIcon)
        XCTAssertTrue(loadingViewModel.showExtraInfo ?? false)
    }
    
    private func assert(images: [PhotoImageViewModel], data: [ChildrenData]) {
        XCTAssertEqual(images.count, data.count)
        for index in 0...(data.count-1) {
            let image = images[index]
            let children = data[index]
            XCTAssertEqual(image.thumbnailUrl, children.data?.thumbnail)
            XCTAssertEqual(image.imageUrl, children.data?.url)
            XCTAssertEqual(image.title, children.data?.title)
            XCTAssertEqual(image.author, children.data?.author_fullname)
        }
    }
    
    private func getFakeChildrens() -> [ChildrenData] {
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

}
