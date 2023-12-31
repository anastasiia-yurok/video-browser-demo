//
//  VideosResponse.swift
//  video-browser-demo
//
//  Created by Anastasia Yurok on 04.12.2023.
//

import Foundation

// Represents response of categories/{category}/videos api
struct VideosResponse: Codable {
  let data: [Video]
}
