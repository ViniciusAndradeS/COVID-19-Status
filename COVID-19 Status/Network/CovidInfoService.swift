//
//  CovidInfoService.swift
//  COVID-19 Status
//
//  Created by Vinicius de Andrade Silva on 23/11/20.
//

import Foundation
import Alamofire

protocol Service {
  func getCasesFor(latitude: Double, longitude: Double, completionHandler: @escaping (Result<CovidInfoModel, CustomError>) -> Void)
}

class CovidInfoService: Service {
  
  private func buildURL() -> String {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "services7.arcgis.com"
    components.path = "/mOBPykOjAyBO2ZKk/arcgis/rest/services/RKI_Landkreisdaten/FeatureServer/0/query"
    
    return components.string ?? ""
  }
  
  func getCasesFor(latitude: Double, longitude: Double, completionHandler: @escaping (Result<CovidInfoModel, CustomError>) -> Void) {
    
    
    let parameters: [String: String] = ["outFields": "cases7_per_100k,county",
                                        "geometry": "\(longitude),\(latitude)",
                                        "geometryType": "esriGeometryPoint",
                                        "inSR": "4326",
                                        "f": "json"]
    
    var characterSet = CharacterSet()
    characterSet.formUnion(.lowercaseLetters)
    characterSet.formUnion(.uppercaseLetters)
    characterSet.formUnion(.decimalDigits)
    characterSet.insert(charactersIn: "?=_,&.")
    
    let customEncoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(allowedCharacters: characterSet))
    
    AF.request(buildURL(), parameters: parameters, encoder: customEncoder)
      .responseDecodable(of: CovidInfoModel.self) { response in
        let result = response.result
        
        switch result {
        case .success(let value):
          completionHandler(.success(value))
          break
        case .failure(let error):
            if let urlError = error.underlyingError as? URLError {
              if urlError.code == .notConnectedToInternet {
                completionHandler(.failure(.noInternet))
              }
            }
          completionHandler(.failure(.genericError))
          break
        }
      }
    
  }
  
  
}
