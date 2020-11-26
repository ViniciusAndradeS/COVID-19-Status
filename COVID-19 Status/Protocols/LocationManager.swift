//
//  LocationManager.swift
//  COVID-19 Status
//
//  Created by Vinicius de Andrade Silva on 25/11/20.
//

import CoreLocation

protocol LocationManager {
  
  var location: CLLocation? { get }
  var delegate: CLLocationManagerDelegate? { get set }
  var authorizationStatus: CLAuthorizationStatus { get }
  
  func requestWhenInUseAuthorization()
  
}

extension CLLocationManager: LocationManager {

}
