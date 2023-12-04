//
//  ViewController.swift
//  video-browser-demo
//
//  Created by Anastasia Yurok on 04.12.2023.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet var message: UILabel!

  lazy var authController: AuthController = AuthControllerImpl()

  override func viewDidLoad() {
    super.viewDidLoad()
    Task {
      do {
        try await authController.authenticate()
        message.text = authController.token?.access_token ?? "nil"
      } catch {
        message.text = "Error!"
      }
    }
  }


}

