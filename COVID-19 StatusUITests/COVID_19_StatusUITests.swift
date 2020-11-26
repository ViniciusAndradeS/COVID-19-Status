//
//  COVID_19_StatusUITests.swift
//  COVID-19 StatusUITests
//
//  Created by Vinicius de Andrade Silva on 21/11/20.
//

import XCTest

class COVID_19_StatusUITests: XCTestCase {
  
  let app = XCUIApplication()
  
  override func setUpWithError() throws {
    app.launchArguments.append("-UI-Testing")
  }
  
  func testShowWelcome() throws {
    app.launchArguments += ["-wasWelcomeScreenSeen", "NO"]
    app.launch()
            
    XCTAssertTrue(app.staticTexts["COVID-19 Status"].exists)
    XCTAssertTrue(app.staticTexts["Keep up with the cases in your region"].exists)
    XCTAssertTrue(app.staticTexts["Continue"].exists)
  }
  
  func testPageAutoScroll() throws {
    app.launchArguments += ["-wasWelcomeScreenSeen", "NO"]
    app.launch()
    
    sleep(5)
            
    XCTAssertTrue(app.staticTexts["COVID-19 Status"].exists)
    XCTAssertTrue(app.staticTexts["Learn about the guidelines to protect you and your community"].exists)
    XCTAssertTrue(app.staticTexts["Continue"].exists)
  }
  
  func testPageManualScroll() throws {
    app.launchArguments += ["-wasWelcomeScreenSeen", "NO"]
    app.launch()
    
    app.collectionViews.cells.otherElements.containing(.staticText, identifier:"Keep up with the cases in your region").element.swipeLeft()
    
    XCTAssertTrue(app.staticTexts["COVID-19 Status"].exists)
    XCTAssertTrue(app.staticTexts["Learn about the guidelines to protect you and your community"].waitForExistence(timeout: 5))
    XCTAssertTrue(app.staticTexts["Continue"].exists)
  }
  
  func testHome() throws {
    app.launchArguments += ["-wasWelcomeScreenSeen", "YES"]
    app.launch()
       
    XCTAssertTrue(app.staticTexts["Phase"].exists)
    XCTAssertTrue(app.staticTexts["Green"].exists)
    XCTAssertTrue(app.staticTexts["in Test"].exists)
    XCTAssertTrue(app.staticTexts["10.00 cases/100k people"].exists)
    XCTAssertTrue(app.staticTexts["Check out current guidelines"].exists)
  }
  
  func testGuideline() throws {
    app.launchArguments += ["-wasWelcomeScreenSeen", "YES"]
    app.launch()
    
    app.buttons["bottomButton"].tap()
    
    XCTAssertTrue(app.staticTexts["Always important..."].exists)
    XCTAssertTrue(app.staticTexts["Keep your distance"].exists)
    XCTAssertTrue(app.staticTexts["Precautions in this phase..."].exists)
    XCTAssertTrue(app.staticTexts["   Limitations of face-to-face contact in public spaces"].exists)
  }
  
}
