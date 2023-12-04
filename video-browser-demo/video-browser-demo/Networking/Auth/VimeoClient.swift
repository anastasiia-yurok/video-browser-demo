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
    clientId: "66f98152205688dbd0163d30a40d172b56ca431f",
    secret: "dfqQPpJ5AIOg7bpk3pK/6HfTQ0PAZMEvVaaWs2IlDnQ9Ud6N3rBoyW0lYiiHduzFhjvJPFbpb244QwkkbVGX/w4QldN+PzWEfDwRDcp3O74hKdWwNEUM64qA4h9EQvSh"
  )
  
  var basicAuthToken: String {
    let plainToken = "\(clientId):\(secret)"
    return Data(plainToken.utf8).base64EncodedString()
  }
  
  var basicAuthHeader: String {
    "basic \(basicAuthToken)"
  }
}
