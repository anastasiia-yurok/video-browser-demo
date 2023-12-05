//
//  VideoCollectionCell.swift
//  video-browser-demo
//
//  Created by Anastasia Yurok on 04.12.2023.
//

import UIKit

// Video collection cell to present preview for a certain video
class VideoCollectionCell: UICollectionViewCell {
  static let identifier = "VideoCollectionCell"
  @IBOutlet var imageView: NetworkImage!
  @IBOutlet var titleLabel: UILabel!
  
  let focusColor = UIColor.blue.withAlphaComponent(0.3)
  
  override func awakeFromNib() {
    super.awakeFromNib()
    let view = UIView()
    view.backgroundColor = focusColor
    selectedBackgroundView = view
  }
  
  func updateFocused(_ isFocused: Bool) {
    backgroundColor = isFocused ? focusColor : nil
  }
}
