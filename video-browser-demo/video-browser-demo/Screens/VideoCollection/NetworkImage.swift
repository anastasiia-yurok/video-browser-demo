//
//  NetworkImage.swift
//  video-browser-demo
//
//  Created by Anastasia Yurok on 04.12.2023.
//

import UIKit

// UIImage view capable to download its content.
// If content is not provided the placeholder is displayed.
@MainActor
class NetworkImage: UIImageView {
  var url: URL? {
    didSet {
      if oldValue == url {
        return
      }
      if let url {
        downloadImage(url)
      } else {
        image = Self.placeholderImage
      }
    }
  }
  
  override init(image: UIImage?) {
    super.init(image: image ?? Self.placeholderImage)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.image = Self.placeholderImage
  }
  
  required override init(frame: CGRect) {
    super.init(frame: frame)
    self.image = Self.placeholderImage
  }
  
  private var downloadTask: Task<UIImage?, Never>?
  
  private func downloadImage(_ url: URL) {
    let task = Task<UIImage?, Never> {
      // download data
      guard
        let (data, _) = try? await URLSession.shared.data(from: url),
        let image = UIImage(data: data)
      else {
        return nil
      }
      
      // task is cancelled, exit
      guard !Task.isCancelled else {
        return nil
      }
      
      return image
    }
    
    Task {
      // cancel previous download if needed
      downloadTask?.cancel()
      downloadTask? = task
      
      // download image
      downloadTask = task
      self.image = await task.value ?? Self.placeholderImage
      downloadTask = nil
    }
  }
  
  private static let placeholderImage = UIImage(named: "thumbnail-placeholder")
}
