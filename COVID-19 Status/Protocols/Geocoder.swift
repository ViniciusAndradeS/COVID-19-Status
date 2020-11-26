//
//  Geocoder.swift
//  COVID-19 Status
//
//  Created by Vinicius de Andrade Silva on 25/11/20.
//

import CoreLocation

protocol Geocoder {
  
  func reverseGeocodeLocation(_ location: CLLocation, preferredLocale locale: Locale?, completionHandler: @escaping CLGeocodeCompletionHandler)

}

extension CLGeocoder: Geocoder {

}
