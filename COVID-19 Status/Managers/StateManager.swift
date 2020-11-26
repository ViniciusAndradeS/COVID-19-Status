//
//  StateManager.swift
//  COVID-19 Status
//
//  Created by Vinicius de Andrade Silva on 21/11/20.
//

enum State: Equatable {
  case green
  case yellow
  case red
  case darkRed
  case error(CustomError)
  
  init(name: String) {
    switch name {
    case "Green":
      self = .green
    case "Yellow":
      self = .yellow
    case "Red":
      self = .red
    case "Dark Red":
      self = .darkRed
    default:
      self = .error(.custom(name, ""))
    }
  }
  
  func description() -> String {
    switch self {
    case .green:
      return "Green"
    case .yellow:
      return "Yellow"
    case .red:
      return "Red"
    case .darkRed:
      return "Dark Red"
    case .error(let error):
      return error.title()
    }
  }
  
  static func == (lhs: State, rhs: State) -> Bool {
    return lhs.description() == rhs.description()
  }
  
  func isError() -> Bool {
    switch self {
    case .error(_):
      return true
    default:
      return false
    }
  }
}

class StateManager {
  
  static let shared = StateManager()
  var service: Service = CovidInfoService()
  
  func getStateWithCachedInfo(completionHandler: @escaping (_ state: State) -> Void) {
    let locationTuple = UserDefaultsManager.getCoordinates()
    let administrativeArea = UserDefaultsManager.getAdministrativeArea()
    
    getState(latitude: locationTuple.latitude, longitude: locationTuple.longitude, administrativeArea: administrativeArea) { result in
      completionHandler(result.state)
    }
  }
  
  func getState(latitude: Double,
                longitude: Double,
                administrativeArea: String,
                completionHandler: @escaping ((state: State, info: CovidInfoModel?)) -> Void) {
    
    service.getCasesFor(latitude: latitude, longitude: longitude) { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case .success(let value):
        guard let unwrappedCases = value.cases100k else { completionHandler((.error(.genericError), nil))
          return }
        let state = self.checkState(for: unwrappedCases, in: administrativeArea)
        
        UserDefaultsManager.saveState(state)
        UserDefaultsManager.saveCoordinates(latitude: latitude, longitude: longitude)
        UserDefaultsManager.saveAdministrativeArea(administrativeArea)
        
        completionHandler((state, value))
      case .failure(let error):
        completionHandler((.error(error), nil))
        break
      }
    }
    
  }
  
  private func checkState(for cases100K: Double, in administrativeArea: String) -> State {
    switch cases100K {
    case 0..<35:
      return .green
    case 35..<50:
      return .yellow
    case 50..<100:
      return .red
    case 100...:
      return isBavaria(administrativeArea) ? .darkRed : .red
    default:
      return .error(.genericError)
    }
  }
  
  private func isBavaria(_ administrativeArea: String) -> Bool {
    return administrativeArea == "Bavaria"
  }
  
}
