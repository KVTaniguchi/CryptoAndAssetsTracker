//
//  CryptoAndAssetsTrackerUITests.swift
//  CryptoAndAssetsTrackerUITests
//
//  Created by Kevin Taniguchi on 2/27/18.
//  Copyright © 2018 Taniguchi. All rights reserved.
//

import XCTest

class CryptoAndAssetsTrackerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPickerAppear() {
        
        let app = XCUIApplication()
        let pickerElement = app.pickers["picker"]
        app.tables.buttons["Choose Currency"].tap()
        XCTAssertTrue(pickerElement.exists)
    }
    
    func testVCPush() {
        let app = XCUIApplication()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["DigitalCash"]/*[[".cells.staticTexts[\"DigitalCash\"]",".staticTexts[\"DigitalCash\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertTrue(app.navigationBars["DigitalCash"].exists)
    }

}
