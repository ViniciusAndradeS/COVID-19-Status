//
//  MockCovidInfoService.swift
//  COVID-19 StatusTests
//
//  Created by Vinicius de Andrade Silva on 25/11/20.
//

@testable import COVID_19_Status

class MockCovidInfoService: Service {
  
  var expectedError: CustomError?
  
  func getCasesFor(latitude: Double, longitude: Double, completionHandler: @escaping (Result<CovidInfoModel, CustomError>) -> Void) {
    if let error = expectedError {
      completionHandler(.failure(error))
    } else {
      completionHandler(.success(CovidInfoModel()))
    }
  }

}
