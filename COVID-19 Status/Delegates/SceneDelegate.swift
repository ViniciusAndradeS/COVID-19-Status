//
//  SceneDelegate.swift
//  COVID-19 Status
//
//  Created by Vinicius de Andrade Silva on 21/11/20.
//

import UIKit
import BackgroundTasks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    window?.windowScene = windowScene
    let homeVC = HomeViewController()
    let navigationController = UINavigationController(rootViewController: homeVC)
    window?.rootViewController = UserDefaultsManager.wasWelcomeScreenSeen() ? navigationController : WelcomeViewController()
    window?.makeKeyAndVisible()
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    (UIApplication.shared.delegate as! AppDelegate).scheduleBackgroundFetch()
  }
}

