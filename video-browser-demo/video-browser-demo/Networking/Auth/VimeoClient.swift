//
//  VimeoClient.swift
//  video-browser-demo
//
//  Created by Anastasia Yurok on 04.12.2023.
//

import Foundation

struct VimeoClient {
  let clientId: String
  let secret: String
  
  static var `default` = VimeoClient(
    clientId: "fd3493db9f8755566c7769f6ef567e27902ddf33",
    secret: "Avn7qdYd6mzUW4rADzMJgdG0JazTG7hks3QSHqD65KRcqaVWCGnBYmUOMOR2Xf0XB3XuFkF+lh1hPr5n9IEaiFsu1D1RIZr8PkGK00qlzldWs1fQ7NK+0OytUC9zzRzf"
  )
  
  var basicAuthToken: String {
    let plainToken = "\(clientId):\(secret)"
    return Data(plainToken.utf8).base64EncodedString()
  }
  
  var basicAuthHeader: String {
    "basic \(basicAuthToken)"
  }
}
