//
//  AuthToken.swift
//  video-browser-demo
//
//  Created by Anastasia Yurok on 04.12.2023.
//

import Foundation

// Keeps auth token as it is received from BE
struct AuthToken: Codable {
  let access_token: String
  let token_type: String
  let scope: String
  
  // Constructs authorization header based on content
  var authorizationHeader: String {
    "\(token_type) \(access_token)"
  }
}
