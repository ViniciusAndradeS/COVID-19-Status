//
//  MockGeocoder.swift
//  COVID-19 StatusTests
//
//  Created by Vinicius de Andrade Silva on 25/11/20.
//

import CoreLocation
@testable import COVID_19_Status

class MockGeocoder: Geocoder {
  
  var placemarks: [CLPlacemark]?
  var error: Error?
  
  func reverseGeocodeLocation(_ location: CLLocation, preferredLocale locale: Locale?, completionHandler: @escaping CLGeocodeCompletionHandler) {
    completionHandler(placemarks, error)
  }

}
