//
//  HomeViewModel.swift
//  COVID-19 Status
//
//  Created by Vinicius de Andrade Silva on 23/11/20.
//

import UIKit
import CoreLocation

protocol HomeViewUIDelegate {
  func changed(_ viewModel: HomeViewModel, toState state: State, withInfo info: CovidInfoModel?)
  func goToGuidelines(_ viewModel: HomeViewModel, withState state: State)
}

class HomeViewModel: NSObject {
  
  var locationManager: LocationManager = CLLocationManager()
  var geocoder: Geocoder = CLGeocoder()
  
  var delegate: HomeViewUIDelegate?
  var lastState: State?
  
  @objc
  func checkForState() {
    if ProcessInfo.processInfo.arguments.contains("-UI-Testing") {
      changed(state: .green, and: CovidInfoModel())
    } else {
      locationManager.delegate = self
      locationManager.requestWhenInUseAuthorization()
      
      startCheck()
    }
  }
  
  private func startCheck() {
    if locationManager.authorizationStatus == .authorizedWhenInUse {
      lookForCoodinates()
    } else {
      changed(state: .error(.noLocation), and: nil)
    }
  }
  
  private func lookForCoodinates() {
    let currentLocation = locationManager.location ?? CLLocation()
    
    geocoder.reverseGeocodeLocation(currentLocation, preferredLocale: Locale(identifier: "en_US")) { [weak self] placemarks, error in
      guard let self = self else { return }
      
      guard let placemark = placemarks?.first else {
        self.changed(state: .error(.genericError), and: nil)
        return
      }
      
      if placemark.isoCountryCode == "DE" {
        self.lookForState(coordinate: currentLocation.coordinate, administrativeArea: placemark.administrativeArea ?? "")
      } else {
        UserDefaultsManager.clearLocationData()
        self.changed(state: .error(.outsideGermany), and: nil)
      }
    }
  }
  
  private func lookForState(coordinate: CLLocationCoordinate2D, administrativeArea: String) {
    StateManager.shared.getState(latitude: coordinate.latitude,
                                 longitude: coordinate.longitude,
                                 administrativeArea: administrativeArea) { [weak self] response in
      guard let self = self else { return }
      self.changed(state: response.state, and: response.info)
    }
  }
  
  private func changed(state: State, and info: CovidInfoModel?) {
    lastState = state
    delegate?.changed(self, toState: state, withInfo: info)
  }
  
  func didClickBottomButton() {
    switch lastState {
    case .error(let error):
      bottomButtonErrorBehavior(error)
    default:
      guard let state = lastState else { return }
      delegate?.goToGuidelines(self, withState: state)
    }
  }
  
  private func bottomButtonErrorBehavior(_ error: CustomError) {
    switch error {
    case .noLocation:
      goToSettings()
    case .noInternet, .genericError:
      checkForState()
    default:
      break
    }
  }
  
  private func goToSettings() {
    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
      return
    }
    
    if UIApplication.shared.canOpenURL(settingsUrl) {
      UIApplication.shared.open(settingsUrl)
    }
  }
  
}


extension HomeViewModel: CLLocationManagerDelegate {
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    startCheck()
  }
  
}
