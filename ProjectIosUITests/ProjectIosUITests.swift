import XCTest

@testable import ProjectIos
class ProjectIosUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        let app = XCUIApplication()
        
        app.launch()
    }
    
    func testMasterIsAccessibleOnStartup() {
        let app = XCUIApplication()
        XCTAssert(app.navigationBars["Cities"].exists)
        if !app.navigationBars["Cities"].isHittable {
            XCTAssert(app.buttons["Back"].exists)
        }
    }
    
    func testCellCount() {
        let app = XCUIApplication()
        if !app.navigationBars["Cities"].isHittable {
            app.buttons["Back"].tap()
        }
        XCTAssert(app.collectionViews.cells.count == 5)
        
    }
    
    func testShowAttractionsSegue() {
        let app = XCUIApplication()
        if !app.navigationBars["Cities"].isHittable {
            app.buttons["Back"].tap()
        }
        app.collectionViews.staticTexts["Rome"].tap()
        
        XCTAssert(app.navigationBars["Attractions"].exists)
        XCTAssert(app.tables.staticTexts["Colosseum"].exists)
        
     
    }
    
    func testMasterAccessibleAfterSegue() {
        let app = XCUIApplication()
        if !app.navigationBars["Cities"].isHittable {
            app.buttons["Back"].tap()
        }
        app.collectionViews.staticTexts["Rome"].tap()
        if !app.navigationBars["Cities"].exists {
            XCTAssert(app.buttons["Back"].exists)
        }
    }
    func testCellCountRome() {
        let app = XCUIApplication()
        if !app.navigationBars["Cities"].isHittable {
            app.buttons["Back"].tap()
        }
        app.collectionViews.staticTexts["Rome"].tap()
        XCTAssert(app.tables.cells.count == 8)
        
    }
    func testShowAttractionSegue() {
        let app = XCUIApplication()
        if !app.navigationBars["Cities"].isHittable {
            app.buttons["Back"].tap()
        }
        app.collectionViews.staticTexts["Rome"].tap()
        app.tables.staticTexts["Colosseum"].tap()
        
        XCTAssert(app.navigationBars["Colosseum"].exists)
        
        XCTAssert(app.buttons["Directions"].exists)
        
    }
    
    func testAttractionsAccessibleAfterSegue() {
        let app = XCUIApplication()
        if !app.navigationBars["Cities"].isHittable {
            app.buttons["Back"].tap()
        }
        app.collectionViews.staticTexts["Rome"].tap()
        app.tables.staticTexts["Colosseum"].tap()
        if !app.navigationBars["Attractions"].exists {
            XCTAssert(app.buttons["Back"].exists)
        }
    }
}
