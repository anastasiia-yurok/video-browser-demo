//
//  VideosResponse.swift
//  video-browser-demo
//
//  Created by Anastasia Yurok on 04.12.2023.
//

import Foundation

struct VideosResponse: Codable {
  let data: [Video]
  
  struct Video: Codable {
    let uri: String
    let resource_key: String
    let link: String
    let custom_url: String?
    let is_playable: Bool
    let height: Int
    let width: Int
    let duration: Int
    let description: String
    // let player_embed_url: String
    // let pictures: [Picture]
    let created_time: String
    
    struct Picture: Codable {
      let active: Bool
      let default_picture: Bool
      let base_link: Bool
      let sizes: [Size]
      let uri: String
      let resource_key: String
      
      struct Size: Codable {
        let width: Int
        let height: Int
        let link: String
        let link_with_play_button: String
      }
    }
  }
}
