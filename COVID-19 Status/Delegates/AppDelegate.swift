//
//  AppDelegate.swift
//  COVID-19 Status
//
//  Created by Vinicius de Andrade Silva on 21/11/20.
//

import UIKit
import BackgroundTasks
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  let backgroundFetchID = "com.vinicius.fetchStatus"
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundFetchID, using: nil) { [weak self] task in
      guard let self = self else { return }
      
      self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
    }
    
    return true
  }
  
  func handleAppRefreshTask(task: BGAppRefreshTask) {
    guard let lastState = UserDefaultsManager.getState() else {
      task.setTaskCompleted(success: false)
      return
    }
    StateManager.shared.getStateWithCachedInfo { [weak self] state in
      guard let self = self else { return }
      
      if !state.isError() &&
         !lastState.isError() &&
         state != lastState {
        self.sendNotification(name: state.description())
      }
    }
    
    
    task.setTaskCompleted(success: true)
    
    scheduleBackgroundFetch()
  }
  
  func scheduleBackgroundFetch() {
    let fetchTask = BGAppRefreshTaskRequest(identifier: backgroundFetchID)
    fetchTask.earliestBeginDate = Date(timeIntervalSinceNow: 600)
    do {
      try BGTaskScheduler.shared.submit(fetchTask)
    } catch {
      print("Unable to submit task: \(error.localizedDescription)")
    }
  }
  
  func sendNotification(name: String) {
    let content = UNMutableNotificationContent()
    content.title = "The phase in your area changed to \(name)!"
    content.body = "Open the app to see the new guidelines right now"
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    
    let request = UNNotificationRequest(identifier: UUID().uuidString,
                                        content: content,
                                        trigger: trigger)
    
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.add(request, withCompletionHandler: nil)
  }
  
}

