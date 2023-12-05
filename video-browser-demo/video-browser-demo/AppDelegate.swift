//
//  AppDelegate.swift
//  video-browser-demo
//
//  Created by Anastasia Yurok on 04.12.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  private var appRouter: AppRouter!
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Construct app router
    let assembly = AppAssembly()
    appRouter = AppRouter(assembly: assembly)
    
    // Setup app UI
    self.window = UIWindow(frame:UIScreen.main.bounds)
    window?.rootViewController = appRouter.configureRootNavigation()
    window?.makeKeyAndVisible()

    return true
  }
}

