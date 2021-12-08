//
//  PhotoGalleryTests.swift
//  RedditPhotoGalleryUITests
//
//  Created by Matteo Fattori on 08/12/21.
//

import XCTest

class PhotoGalleryTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        XCUIDevice.shared.orientation = .portrait
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //MARK: Search tests
    
    func test_search_should_show_photos_properly() throws {
        let app = XCUIApplication()
        let searchImagesSearchField = app.searchFields["Search images..."]
        XCTAssertTrue(searchImagesSearchField.exists)
        
        // start searching
        searchImagesSearchField.tap()
        searchImagesSearchField.typeText("forest")
        
        let collectionViewCellsQuery = app.collectionViews.children(matching: .cell)
        
        // wait until search is over then check cells
        expectation(for: NSPredicate(format: "count > 0"), evaluatedWith: collectionViewCellsQuery, handler: nil)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_search_photos_should_show_no_result_found() throws {
        
        let app = XCUIApplication()
        let searchImagesSearchField = app.searchFields["Search images..."]
        XCTAssertTrue(searchImagesSearchField.exists)
        
        searchImagesSearchField.tap()
        // should never find anything with that search
        searchImagesSearchField.typeText("asdaasdasdasdadadasda")
        
        let collectionViewCellsQuery = app.collectionViews.children(matching: .cell)
        let noResultFoundStaticText = app.staticTexts["No Result Found"]
        
        // wait until search is over then check cells and message on view
        expectation(for: NSPredicate(format: "count == 0"), evaluatedWith: collectionViewCellsQuery, handler: nil)
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: noResultFoundStaticText, handler: nil)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_search_photos_should_reset_view_when_clear_search() throws {
        
        let app = XCUIApplication()
        let searchImagesSearchField = app.searchFields["Search images..."]
        XCTAssertTrue(searchImagesSearchField.exists)
        
        searchImagesSearchField.tap()
        searchImagesSearchField.typeText("forest")
        
        // wait for search results
        let collectionViewCellsQuery = app.collectionViews.children(matching: .cell)
        expectation(for: NSPredicate(format: "count > 0"), evaluatedWith: collectionViewCellsQuery, handler: nil)
        
        waitForExpectations(timeout: 10, handler: nil)
        
        // clear search text
        searchImagesSearchField.buttons["Clear text"].tap()
        
        // wait until search is over then check cells and message on view
        let pleaseWriteSomethingStaticText = app.staticTexts["Please write something..."]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: pleaseWriteSomethingStaticText, handler: nil)
        expectation(for: NSPredicate(format: "count == 0"), evaluatedWith: collectionViewCellsQuery, handler: nil)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
