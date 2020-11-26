//
//  HomeViewModelTests.swift
//  COVID-19 StatusTests
//
//  Created by Vinicius de Andrade Silva on 21/11/20.
//

import CoreLocation
import XCTest
@testable import COVID_19_Status

class HomeViewModelTests: XCTestCase {
  
  let timeInterval: Double = 15
  let viewModel = HomeViewModel()
  let locationSaoPaulo = CLLocation(latitude: -23.533773, longitude: -46.625290)
  let locationMunich = CLLocation(latitude: 48.13743, longitude: 11.57549)
  
  var onDelegateHit: ((DelegateHit) -> Void)?
  
  enum DelegateHit {
    case didGetState(State, CovidInfoModel?)
    case goToGuidelines
  }
  
  override func setUpWithError() throws {
    viewModel.delegate = self
  }
  
  func testNotAuthorized() throws {
    let expectation = self.expectation(description: "Wait for delegate")
    
    let locationManager = MockLocationManager()
    locationManager.authorizationStatus = .denied
    
    viewModel.locationManager = locationManager
    
    onDelegateHit = { hit in
      
      switch hit {
      case .didGetState(let state, _):
        if state == .error(.noLocation) {
          expectation.fulfill()
        }
      default:
        break
      }
    }
    
    viewModel.checkForState()
    
    waitForExpectations(timeout: timeInterval, handler: nil)
  }
  
  func testNoPlacemarks() throws {
    let expectation = self.expectation(description: "Wait for delegate")
    
    let locationManager = MockLocationManager()
    let geocoder = MockGeocoder()
    
    viewModel.locationManager = locationManager
    viewModel.geocoder = geocoder
    
    onDelegateHit = { hit in
      switch hit {
      case .didGetState(let state, _):
        if state == .error(.genericError) {
          expectation.fulfill()
        }
      default:
        break
      }
    }
    
    viewModel.checkForState()
    
    waitForExpectations(timeout: timeInterval, handler: nil)
  }
  
  func testOutsideGermany() throws {
    let expectation = self.expectation(description: "Wait for delegate")
    
    let locationManager = MockLocationManager()
    locationManager.location = locationSaoPaulo
    let geocoder = CLGeocoder()
    
    viewModel.locationManager = locationManager
    viewModel.geocoder = geocoder
    
    onDelegateHit = { hit in
      switch hit {
      case .didGetState(let state, _):
        if state == .error(.outsideGermany) {
          expectation.fulfill()
        }
      default:
        break
      }
    }
    
    viewModel.checkForState()
    
    waitForExpectations(timeout: timeInterval, handler: nil)
  }
  
  func testResponseError() throws {
    let expectation = self.expectation(description: "Wait for delegate")
    
    let locationManager = MockLocationManager()
    locationManager.location = locationMunich
    let geocoder = CLGeocoder()
    
    viewModel.locationManager = locationManager
    viewModel.geocoder = geocoder
    
    let covidInfoService = MockCovidInfoService()
    covidInfoService.expectedError = .genericError
    
    StateManager.shared.service = covidInfoService
    
    onDelegateHit = { hit in
      switch hit {
      case .didGetState(let state, _):
        if state == .error(.genericError) {
          expectation.fulfill()
        }
      default:
        break
      }
    }
    
    viewModel.checkForState()
    
    waitForExpectations(timeout: timeInterval, handler: nil)
  }
  
  func testResponseSuccess() throws {
    let expectation = self.expectation(description: "Wait for delegate")
    
    let locationManager = MockLocationManager()
    locationManager.location = locationMunich
    let geocoder = CLGeocoder()
    
    viewModel.locationManager = locationManager
    viewModel.geocoder = geocoder
    
    let covidInfoService = MockCovidInfoService()
    covidInfoService.expectedError = nil
    
    StateManager.shared.service = covidInfoService
    
    onDelegateHit = { hit in
      switch hit {
      case .didGetState(let state, _):
        if !state.isError() {
          expectation.fulfill()
        }
      default:
        break
      }
    }
    
    viewModel.checkForState()
    
    waitForExpectations(timeout: timeInterval, handler: nil)
  }
  
  func testGoToGuidelines() throws {
    let expectation = self.expectation(description: "Wait for delegate")
    
    viewModel.lastState = .green
    
    onDelegateHit = { hit in
      switch hit {
      case .goToGuidelines:
        expectation.fulfill()
      default:
        break
      }
    }
    
    viewModel.didClickBottomButton()
    
    waitForExpectations(timeout: timeInterval, handler: nil)
  }
  
}

extension HomeViewModelTests: HomeViewUIDelegate {
  
  func changed(_ viewModel: HomeViewModel, toState state: State, withInfo info: CovidInfoModel?) {
    onDelegateHit?(.didGetState(state, info))
  }
  
  func goToGuidelines(_ viewModel: HomeViewModel, withState state: State) {
    onDelegateHit?(.goToGuidelines)
  }
  
}
