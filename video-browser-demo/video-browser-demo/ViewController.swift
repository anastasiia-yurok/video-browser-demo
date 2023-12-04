//
//  ViewController.swift
//  video-browser-demo
//
//  Created by Anastasia Yurok on 04.12.2023.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet var message: UILabel!

  lazy var httpClient: HTTPClient = HTTPClientImpl(host: URL(string: "https://api.vimeo.com")!)
  lazy var authController: AuthController = AuthControllerImpl(httpClient: httpClient)
  lazy var categoriesApi: CategoriesApi = CategoriesApiImpl(client: httpClient, authController: authController)

  override func viewDidLoad() {
    super.viewDidLoad()
    Task {
      do {
        try await authController.authenticate()
        message.text = authController.token?.access_token ?? "nil"

        let videos = try await categoriesApi.getVideosOfCategory(named: "sports")
        message.text = "videos count = \(videos.data.count)"
      } catch {
        message.text = "Error!"
      }
    }
  }


}

