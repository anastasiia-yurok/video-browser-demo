//
//  AuthController.swift
//  video-browser-demo
//
//  Created by Anastasia Yurok on 04.12.2023.
//

import Foundation

enum AuthError: Error {
  // Invalid grant type
  case invalidGrantType
  // This user cannot be authorized
  case unauthorized
  // Other response error. Associated value contains payload from network response.
  case unknownNetworkError(String?)
  // Unable to parse response json
  case responseParsingFailure(String)
}

// Responsible for performing authentication to Vimeo.
protocol AuthController {
  // If authenticated returns correspondent auth token
  var token: AuthToken? { get }
  // Performs authentication
  func authenticate() async throws
}

class AuthControllerImpl: AuthController {
  private(set) var token: AuthToken?
  private let httpClient: HTTPClient
  
  init(httpClient: HTTPClient) {
    self.httpClient = httpClient
  }
  
  func authenticate() async throws {
    let data: Data
    do {
      data = try await httpClient.data(
        with: Self.authPath,
        query: [],
        method: "POST",
        authHeader: VimeoClient.default.basicAuthHeader,
        headers: [:],
        body: [
          "grant_type": "client_credentials",
          "scope": "public private video_files"
        ]
      )
    } catch HTTPClientError.networkError(let statusCode, let errorData) {
      switch statusCode {
      case 400:
        throw AuthError.invalidGrantType
      case 401:
        throw AuthError.unauthorized
      default:
        throw AuthError.unknownNetworkError(errorData.flatMap { decodeError(from: $0) })
      }
    }
    
    do {
      self.token = try JSONDecoder().decode(AuthToken.self, from: data)
    } catch {
      throw AuthError.responseParsingFailure(error.localizedDescription)
    }
  }
  
  // MARK: - Private
  private static let authPath = "oauth/authorize/client"
  
  private func decodeError(from data: Data) -> String? {
    // TODO: implement better network parsing
    String(data: data, encoding: .utf8)
  }
}
