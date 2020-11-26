//
//  CovidInfoModel.swift
//  COVID-19 Status
//
//  Created by Vinicius de Andrade Silva on 23/11/20.
//

struct CovidInfoModel: Decodable {
  
  var cases100k: Double?
  var county: String?
  
  init() {
    cases100k = 10
    county = "Test"
  }
  
  enum CodingKeys: String, CodingKey {
    case cases100k = "cases7_per_100k"
    case county
  }
  
  enum UpLevelCodingKeys: String, CodingKey {
    case attributes
  }
  
  enum RootLevelCodingKeys: String, CodingKey {
    case features
  }
  
  init(from decoder: Decoder) throws {
    
    let container = try decoder.container(keyedBy: RootLevelCodingKeys.self)
    
    var features = try container.nestedUnkeyedContainer(forKey: .features)
    
    while !features.isAtEnd {
      let feature = try features.nestedContainer(keyedBy: UpLevelCodingKeys.self)
      
      let attributes = try feature.nestedContainer(keyedBy: CodingKeys.self, forKey: .attributes)
      
      cases100k = try attributes.decode(Double.self, forKey: .cases100k)
      
      county = try attributes.decode(String.self, forKey: .county)
    }
    
  }
  
}
