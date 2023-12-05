//
//  AppRouter.swift
//  video-browser-demo
//
//  Created by Anastasia Yurok on 05.12.2023.
//

import UIKit

// Class responsible for app high level routing.
@MainActor
class AppRouter {
  let assembly: AppAssembly
  var navigationController: UINavigationController!
  
  init(assembly: AppAssembly) {
    self.assembly = assembly
  }
  
  // Instantiates app root navigation stack with initial view controller
  func configureRootNavigation() -> UINavigationController {
    let initialScreen = createInitialScreen()
    navigationController = UINavigationController(rootViewController: initialScreen)
    return navigationController
  }
  
  // Instantiates app initial view controller
  private func createInitialScreen() -> UIViewController {
    return assembly.createInitialViewController(
      router: { [weak self] route in
        guard let self = self else { return }
        switch route {
        case .playVideo(let video):
          let nextController = self.createVideoController(for: video)
          self.navigationController.pushViewController(nextController, animated: true)
        }
      }
    )
  }
  
  // Instantiates Video player controller
  private func createVideoController(for video: Video) -> UIViewController {
    assembly.createVideoPlayerController(
      for: video,
      router: { [weak self] route in
        guard let self = self else { return }
        switch route {
        case .goBack:
          self.navigationController.popViewController(animated: true)
        }
      }
    )
  }
}
