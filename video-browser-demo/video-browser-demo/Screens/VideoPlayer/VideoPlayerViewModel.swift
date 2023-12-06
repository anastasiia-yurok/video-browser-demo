//
//  VideoPlayerViewModel.swift
//  video-browser-demo
//
//  Created by Anastasia Yurok on 05.12.2023.
//

import Foundation

@MainActor
protocol VideoPlayerViewModel {
  var playUrl: URL? { get }
  func onGoBack()
}

enum VideoPlayerRoute {
  case goBack
}
typealias VideoPlayerRouter = (VideoPlayerRoute) -> Void

@MainActor
class VideoPlayerViewModelImpl: VideoPlayerViewModel {
  let video: Video
  private let router: VideoPlayerRouter
  
  init(
    video: Video,
    router: @escaping VideoPlayerRouter
  ) {
    self.video = video
    self.router = router
  }
  
  // MARK: - VideoPlayerViewModel
  var playUrl: URL? {
    let urlString = video.files?.first(where: { $0.quality == .mobile })?.link ??
    // Workaround since files are not returned from BE for some reason.
    // Use some mock video link instead.
    "https://static.pexels.com/lib/videos/free-videos.mp4"
    return .init(string: urlString)
  }
  
  func onGoBack() {
    router(.goBack)
  }
}
