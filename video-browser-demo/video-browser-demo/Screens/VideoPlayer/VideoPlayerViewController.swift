//
//  VideoPlayerViewController.swift
//  video-browser-demo
//
//  Created by Anastasia Yurok on 05.12.2023.
//

import UIKit
import AVKit

@MainActor
class VideoPlayerViewController: AVPlayerViewController {
  @IBOutlet var videoPlayerView: UIView!
  
  var viewModel: VideoPlayerViewModel!
  
  // MARK: - Creation
  static func loadFromStoryboard() -> Self? {
    let storyboard = UIStoryboard(
      name: "VideoPlayerViewController",
      bundle: Bundle(for: self.classForCoder())
    )
    return storyboard.instantiateViewController(identifier: "VideoPlayerViewController") as? Self
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBackButton()
    setupPlayer()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  // MARK: - UI
  private func setupBackButton() {
    let button = UIButton(
      type: .system,
      primaryAction: .init(
        title: "Go Back",
        handler: { [weak self] _ in
          self?.viewModel?.onGoBack()
        }
      )
    )
    button.setTitleColor(.white, for: .normal)
    navigationItem.leftBarButtonItem = .init(customView: button)
  }
  
  func setupPlayer() {
    guard let playUrl = viewModel.playUrl else {
      return
    }
    
    // Create player
    player = AVPlayer(url: playUrl)
    
    // Configure player
    showsPlaybackControls = true
    showsTimecodes = true
    
    // Play
    player?.play()
  }
}
