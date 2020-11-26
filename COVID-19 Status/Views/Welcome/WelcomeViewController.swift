//
//  WelcomeViewController.swift
//  COVID-19 Status
//
//  Created by Vinicius de Andrade Silva on 24/11/20.
//

import UIKit
import CoreLocation
import UserNotifications

class WelcomeViewController: UIViewController {
  
  @IBOutlet weak var continueButton: UIButton!
  @IBOutlet weak var stackView: UIStackView!
  
  private let locationManager = CLLocationManager()
  private let notificationCenter = UNUserNotificationCenter.current()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let steps = PagingViewController(dataSource: PagesRepository.getWelcomeGuidelines(),
                                     title: "COVID-19 Status")
    
    addChild(steps)
    stackView.addArrangedSubview(steps.view)
    steps.didMove(toParent: self)
    
    continueButton.setTitle("Continue".localized, for: .normal)
    continueButton.layer.cornerRadius = continueButton.frame.height/2
  }
  
  @IBAction func continueAction(_ sender: Any) {
    
    locationManager.requestWhenInUseAuthorization()
    
    notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
      UserDefaultsManager.didSeeWelcomeScreen()
      
      DispatchQueue.main.async {
        let homeVC = HomeViewController()
        let navigationController = UINavigationController(rootViewController: homeVC)
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController = navigationController
      }
    }
    
  }
  
}
