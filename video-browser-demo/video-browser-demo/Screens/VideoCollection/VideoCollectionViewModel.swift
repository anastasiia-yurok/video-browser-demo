//
//  VideoCollectionViewModel.swift
//  video-browser-demo
//
//  Created by Anastasia Yurok on 04.12.2023.
//

import Foundation

@MainActor
protocol VideoCollectionViewModel {
  var navigationTitle: String { get }
  var highlitedItemIndex: Int? { get }
  func onViewDidLoad()
  func onItemSelected(_ index: Int)
}

enum VideoCollectionRoute {
  case playVideo(Video)
}
typealias VideoCollectionRouter = (VideoCollectionRoute) -> Void

@MainActor
class VideoCollectionViewModelImpl: VideoCollectionViewModel {
  private let videoApi: CategoriesApi
  private weak var view: VideoCollectionView?
  private let router: VideoCollectionRouter
  
  // Category to be presented
  private let categoryName = "sports"
  
  private var videos: [Video] = [] {
    didSet {
      determineHighlitedItemIndex()
      // transform model objects to view models
      view?.setPreviews(
        videos.map { VideoPreview(name: $0.name, imageUrl: $0.pictures.base_link) }
      )
    }
  }
  
  private var highlitedItemUri: String? {
    didSet {
      determineHighlitedItemIndex()
    }
  }

  private(set) var highlitedItemIndex: Int?
  
  // MARK: - Init
  init(
    videoApi: CategoriesApi,
    view: VideoCollectionView,
    router: @escaping VideoCollectionRouter
  ) {
    self.videoApi = videoApi
    self.view = view
    self.router = router
  }
  
  // MARK: - UI
  var navigationTitle: String {
    return "Sports Videos"
  }
  
  // MARK: - UI Callbacks
  func onViewDidLoad() {
    downloadItems()
  }
  
  func onItemSelected(_ index: Int) {
    guard videos.count > index else {
      return
    }
    // play video for selected item
    let video = videos[index]
    highlitedItemUri = video.uri
    router(.playVideo(video))
  }
  
  // MARK: - Private
  func downloadItems() {
    Task {
      do {
        videos = try await videoApi.getVideosOfCategory(named: categoryName)
      } catch {
        print("Failed to download videos: \(error.localizedDescription)")
      }
    }
  }
  
  
  private func determineHighlitedItemIndex() {
    guard let highlitedItemUri else {
      highlitedItemIndex = nil
      return
    }
    highlitedItemIndex = videos.firstIndex(where: { $0.uri == highlitedItemUri })
  }
}
