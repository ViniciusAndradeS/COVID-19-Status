//
//  PagesRepository.swift
//  COVID-19 Status
//
//  Created by Vinicius de Andrade Silva on 22/11/20.
//

import UIKit

class PagesRepository {
  
  static func getWelcomeGuidelines() -> [PageInfo] {
    return [PageInfo(title: "Keep up with the cases in your region",
                     image: UIImage(named: "House")),
            PageInfo(title: "Learn about the guidelines to protect you and your community",
                     image: UIImage(named: "Prevent")),
            PageInfo(title: "Grant us permission to check the cases based in your GPS location",
                     image: UIImage(named: "Directions")),
            PageInfo(title: "Allow us to send you notification to inform you about the latest changes",
                     image: UIImage(named: "Settings"))]
  }
  
  static func getStandardGuidelines(for state: State) -> [PageInfo] {
    var pages: [PageInfo] = []
    let name = state.description()
    
    pages.append(PageInfo(title: "Keep your distance", image: UIImage(named: "KeepDistance-\(name)")))
    pages.append(PageInfo(title: "Wear a mask", image: UIImage(named: "MaskWearing-\(name)")))
    pages.append(PageInfo(title: "Wash your hands", image: UIImage(named: "Handwashing-\(name)")))
    pages.append(PageInfo(title: "Air rooms regularly", image: UIImage(named: "Window-\(name)")))
    
    return pages
  }
  
  static func getPhaseGuidelines(for state: State) -> [PageInfo] {
    var pages: [PageInfo] = []
    let name = state.description().trimmingCharacters(in: CharacterSet(charactersIn: " "))
    
    switch state {
    case .green:
      
      pages.append(PageInfo(title: """
                                      Limitations of face-to-face contact in public spaces
                                   """.localized,
                            image: UIImage(named: "FaceToFace-\(name)")))
      
      pages.append(PageInfo(title: """
                                      Private events (i.e. weddings etc.) with a maximum of 100 participants in closed spaces and \
                                      a maximum of 200 participants in the open
                                   """.localized,
                            image: UIImage(named: "Celebration-\(name)")))
      
      pages.append(PageInfo(title: """
                                      Wearing a mask is mandatory when (including, but not limited to) using public transportation, \
                                      going shopping, eating and drinking in restaurants, bars, etc. and in case minimum distance (1.5m) \
                                      cannot be kept
                                   """.localized,
                            image: UIImage(named: "PublicMaskWearing-\(name)")))
      
    case .yellow:
      
      pages.append(PageInfo(title: """
                                      Private parties and contacts: no more than two households or ten people
                                   """.localized, image: UIImage(named: "Celebration-\(name)")))
      pages.append(PageInfo(title: """
                                      Wearing a mask is mandatory in heavily frequented spaces, in pedestrian zones, in public buildings, \
                                      for all grades during class, in universities, for attendees of (sports) events, etc.
                                   """.localized,
                            image: UIImage(named: "PublicMaskWearing-\(name)")))
      
      pages.append(PageInfo(title: """
                                      Curfew and ban on selling as well as consuming alcohol in public spaces from 22:00 on
                                   """.localized,
                            image: UIImage(named: "Alcohol-\(name)")))
      
    case .red:
      
      pages.append(PageInfo(title: """
                                      Private parties and contacts: no more than 5 households or five people
                                   """.localized,
                            image: UIImage(named: "Celebration-\(name)")))
      
      pages.append(PageInfo(title: """
                                      Wearing a mask is mandatory in heavily frequented spaces, in pedestrian zones, in public buildings, \
                                      for all grades during class, in universities, for attendees of (sports) events, etc.
                                   """.localized,
                            image: UIImage(named: "PublicMaskWearing-\(name)")))
      
      pages.append(PageInfo(title: """
                                      Curfew and ban on selling as well as consuming alcohol in public spaces from 22:00 on
                                   """.localized,
                            image: UIImage(named: "Alcohol-\(name)")))
      
    case .darkRed:
      
      pages.append(PageInfo(title: """
                                      Events (e.g. club meetings, sporting events, cultural events, etc.) must not exceed 50 persons
                                   """.localized,
                            image: UIImage(named: "PublicMaskWearing-\(name)")))
      
      pages.append(PageInfo(title: """
                                      Closing time for food/gastronomy outlets, ban on alcohol sales and alcohol consumption sales in \
                                      specific public places form 21:00
                                   """.localized,
                            image: UIImage(named: "Alcohol-\(name)")))
      
    default:
      break
    }
    
    return pages
  }
  
}
