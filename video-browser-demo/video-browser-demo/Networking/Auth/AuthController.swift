//
//  AuthController.swift
//  video-browser-demo
//
//  Created by Anastasia Yurok on 04.12.2023.
//

import Foundation

enum AuthError: Error {
  case invalidGrantType
  case unauthorized
  case badResponseData
  case unknownNetworkError(String?)
  case internalError(String)
}

protocol AuthController {
  var token: AuthToken? { get }
  func authenticate() async throws
}

class AuthControllerImpl: AuthController {
  private(set) var token: AuthToken?
  
  func authenticate() async throws {
    guard let url = URL(string: Self.authUrl) else {
      throw AuthError.internalError("Invalid auth url")
    }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    urlRequest.allHTTPHeaderFields = [
      "Authorization": VimeoClient.default.basicAuthHeader,
      "Content-Type": "application/json",
      "Accept": "application/vnd.vimeo.*+json;version=3.4"
    ]
    
    let body = [
      "grant_type": "client_credentials",
      "scope": "public"
    ]
    do {
      urlRequest.httpBody = try JSONEncoder().encode(body)
    } catch {
      throw AuthError.internalError("Failed to decode auth request body")
    }
    
    let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
    
    guard let httpResponse = urlResponse as? HTTPURLResponse else {
      throw AuthError.unknownNetworkError("Unexpected response")
    }
    
    switch httpResponse.statusCode {
    case 200..<300:
      do {
        self.token = try JSONDecoder().decode(AuthToken.self, from: data)
      } catch {
        self.token = nil
        throw AuthError.badResponseData
      }
    case 400:
      throw AuthError.invalidGrantType
    case 401:
      throw AuthError.unauthorized
    default:
      throw AuthError.unknownNetworkError(decodeError(from: data))
    }
  }
  
  private func decodeError(from data: Data) -> String? {
    // TODO: implement better network parsing
    String(data: data, encoding: .utf8)
  }
  
  // MARK: - Private
  private static let authUrl = "https://api.vimeo.com/oauth/authorize/client"
}
