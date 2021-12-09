//
//  PhotoDetailsTests.swift
//  RedditPhotoGalleryUITests
//
//  Created by Matteo Fattori on 08/12/21.
//

import XCTest

class PhotoDetailsTests: XCTestCase {
    
    let textToSearch = "batman"

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        
        app.launch()
        XCUIDevice.shared.orientation = .portrait
        
        let searchImagesSearchField = app.searchFields["Search images..."]
        XCTAssertTrue(searchImagesSearchField.exists)
        
        searchImagesSearchField.tap()
        searchImagesSearchField.typeText(self.textToSearch)
        
        // wait for search results
        let collectionViewCellsQuery = app.collectionViews.children(matching: .cell)
        expectation(for: NSPredicate(format: "count > 0"), evaluatedWith: collectionViewCellsQuery, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        
        // show details of the first cell
        collectionViewCellsQuery.element(boundBy: 0).tap()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //MARK: Back tests
    
    func test_back_button_should_dismiss_view() throws {
        let app = XCUIApplication()
        
        let backButton = app.buttons["BackButton"]
        
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backButton, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_title_author_and_image_should_be_present() throws {
        
        let app = XCUIApplication()
        
        let titleLabel = app.staticTexts["TitleLabel"]
        let authorLabel = app.staticTexts["AuthorLabel"]
        let imageView = app.images["ImageView"]
        
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: titleLabel, handler: nil)
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: authorLabel, handler: nil)
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: imageView, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }

}
