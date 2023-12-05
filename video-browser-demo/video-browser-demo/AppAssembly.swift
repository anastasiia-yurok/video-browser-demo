//
//  AppAssembly.swift
//  video-browser-demo
//
//  Created by Anastasia Yurok on 04.12.2023.
//

import UIKit

// Class responsible for assemblying app screens with proper dependencies
@MainActor
class AppAssembly {
  lazy var httpClient: HTTPClient = HTTPClientImpl(host: URL(string: "https://api.vimeo.com")!)
  lazy var authController: AuthController = AuthControllerImpl(httpClient: httpClient)
  lazy var categoriesApi: CategoriesApi = CategoriesApiImpl(
    client: httpClient,
    authController: authController
  )
  
  // MARK: - Screens
  
  // Assemles app initial view - video collection gallery
  func createInitialViewController(router: @escaping VideoCollectionRouter) -> VideoCollectionViewController {
    let controller = VideoCollectionViewController.loadFromStoryboard()
    let viewModel = VideoCollectionViewModelImpl(
      videoApi: categoriesApi,
      view: controller,
      router: router
    )
    controller.viewModel = viewModel
    return controller
  }
  
  // Assemles video player view for certain video
  func createVideoPlayerController(
    for video: Video,
    router: @escaping VideoPlayerRouter
  ) -> UIViewController {
    let viewModel = VideoPlayerViewModelImpl(video: video, router: router)
    let controller = VideoPlayerViewController.loadFromStoryboard()!
    controller.viewModel = viewModel
    return controller
  }
}
