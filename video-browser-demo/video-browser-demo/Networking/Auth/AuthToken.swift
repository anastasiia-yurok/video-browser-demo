//
//  AuthToken.swift
//  video-browser-demo
//
//  Created by Anastasia Yurok on 04.12.2023.
//

import Foundation

struct AuthToken: Codable {
  let access_token: String
  let token_type: String
  let scope: String
  
  var authorizationHeader: String {
    "\(token_type) \(access_token)"
  }
}
