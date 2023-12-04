//
//  HTTPClient.swift
//  video-browser-demo
//
//  Created by Anastasia Yurok on 04.12.2023.
//

import Foundation

enum HTTPClientError: Error {
  case internalError(String)
  case networkError(Int, Data?)
}

protocol HTTPClient {
  func data(
    with path: String,
    method: String,
    authHeader: String,
    headers: [String: String],
    body: Encodable?
  ) async throws -> Data
}

class HTTPClientImpl: HTTPClient {
  let hostUrl: URL
  
  init(host: URL) {
    hostUrl = host
  }
  
  func data(
    with path: String,
    method: String,
    authHeader: String,
    headers: [String : String],
    body: Encodable?
  ) async throws -> Data {
    let url = hostUrl.appending(path: path)
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = method
    urlRequest.allHTTPHeaderFields = [
      "Authorization": authHeader,
      "Content-Type": "application/json",
      "Accept": "application/vnd.vimeo.*+json;version=3.4"
    ]
    
    if let body = body {
      do {
        urlRequest.httpBody = try JSONEncoder().encode(body)
      } catch {
        throw HTTPClientError.internalError("Failed to decode request body: \(error.localizedDescription)")
      }
    }
    
    let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
    
    guard let httpResponse = urlResponse as? HTTPURLResponse else {
      throw HTTPClientError.internalError("Unexpected network response")
    }
    
    switch httpResponse.statusCode {
    case 200..<300:
      return data
    default:
      throw HTTPClientError.networkError(httpResponse.statusCode, data)
    }
  }
}
