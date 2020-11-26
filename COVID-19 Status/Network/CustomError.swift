//
//  CustomError.swift
//  COVID-19 Status
//
//  Created by Vinicius de Andrade Silva on 23/11/20.
//

enum CustomError: Error {
  case noInternet
  case noLocation
  case outsideGermany
  case genericError
  case custom(String, String)
  
  func title() -> String {
    switch self {
    case .noInternet:
      return "No Internet"
    case .noLocation:
      return "Could not locate"
    case .outsideGermany:
      return "Outside Germany"
    case .genericError:
      return "An error has occured"
    case .custom(let title, _):
      return title
    }
  }
  
  func message() -> String {
    switch self {
    case .noInternet:
      return "Check your connection to the internet and try again"
    case .noLocation:
      return "Please allow the access to your location in your iPhone's Settings"
    case .outsideGermany:
      return "This app can only show guidelines in Germany"
    case .genericError:
      return "An unexpected error has occured, please try again later"
    case .custom(_, let message):
      return message
    }
  }
}
