//
//  Video.swift
//  video-browser-demo
//
//  Created by Anastasia Yurok on 05.12.2023.
//

import Foundation

// Video info provided by BE
struct Video: Codable {
  let uri: String
  let link: String
  let name: String
  let pictures: Picture
  let files: [VideoFile]? // NOT available for some reason
  
  struct Picture: Codable {
    let base_link: String
  }
  
  struct VideoFile: Codable {
    enum Quality: String, Codable {
      // The video is in high definition
      case hd
      // The video is suitable for HTTP live streaming.
      case hls
      // The video is mobile quality.
      case mobile
      // The video is in standard definition.
      case sd
      // The video's source file.
      case source
      // The video resolution is 2K or higher.
      case uhd
    }
    
    let quality: Quality
    let link: String
  }
}
