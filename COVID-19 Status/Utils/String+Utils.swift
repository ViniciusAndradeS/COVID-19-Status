//
//  String+Utils.swift
//  COVID-19 Status
//
//  Created by Vinicius de Andrade Silva on 24/11/20.
//

import Foundation

protocol Localizable {
  var localized: String { get }
}

extension String: Localizable {
  var localized: String {
    return NSLocalizedString(self, comment: "")
  }
}
