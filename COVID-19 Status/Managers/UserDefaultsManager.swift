//
//  UserDefaultsManager.swift
//  COVID-19 Status
//
//  Created by Vinicius de Andrade Silva on 24/11/20.
//

import Foundation

class UserDefaultsManager {
  
  static func saveState(_ state: State) {
    let userDefaults = UserDefaults.standard
    
    userDefaults.set(state.description(), forKey: "state")
  }
  
  static func getState() -> State? {
    let userDefaults = UserDefaults.standard
    
    if let stateName = userDefaults.string(forKey: "state") {
      return State(name: stateName)
    } else {
      return nil
    }
  }
  
  static func saveCoordinates(latitude: Double, longitude: Double) {
    let userDefaults = UserDefaults.standard
    
    userDefaults.set(latitude, forKey: "latitude")
    userDefaults.set(longitude, forKey: "longitude")
  }
  
  static func getCoordinates() -> (latitude: Double, longitude: Double) {
    let userDefaults = UserDefaults.standard
    
    let latitude = userDefaults.double(forKey: "latitude")
    let longitude = userDefaults.double(forKey: "longitude")
    
    return (latitude, longitude)
  }
  
  static func saveAdministrativeArea(_ administrativeArea: String) {
    let userDefaults = UserDefaults.standard
    
    userDefaults.set(administrativeArea, forKey: "administrativeArea")
  }
  
  static func getAdministrativeArea() -> String {
    let userDefaults = UserDefaults.standard
    
    return userDefaults.string(forKey: "administrativeArea") ?? ""
  }
  
  static func clearLocationData() {
    let userDefaults = UserDefaults.standard
    
    userDefaults.removeObject(forKey: "latitude")
    userDefaults.removeObject(forKey: "longitude")
    userDefaults.removeObject(forKey: "administrativeArea")
  }
  
  static func didSeeWelcomeScreen() {
    let userDefaults = UserDefaults.standard
    
    userDefaults.set(true, forKey: "wasWelcomeScreenSeen")
  }
  
  static func wasWelcomeScreenSeen() -> Bool {
    let userDefaults = UserDefaults.standard
    
    return userDefaults.bool(forKey: "wasWelcomeScreenSeen")
  }
  
}
