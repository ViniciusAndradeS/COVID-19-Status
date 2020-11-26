//
//  MockLocationManager.swift
//  COVID-19 StatusTests
//
//  Created by Vinicius de Andrade Silva on 25/11/20.
//

import CoreLocation
@testable import COVID_19_Status

class MockLocationManager: LocationManager {
  
  var location: CLLocation?
  var delegate: CLLocationManagerDelegate?
  var authorizationStatus: CLAuthorizationStatus = .authorizedWhenInUse
  
  func requestWhenInUseAuthorization() {
  }

}
