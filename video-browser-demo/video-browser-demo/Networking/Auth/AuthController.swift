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
  case unknownNetworkError(String?)
  case internalError(String)
}

protocol AuthController {
  var token: AuthToken? { get }
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
        method: "POST",
        authHeader: VimeoClient.default.basicAuthHeader,
        headers: [:],
        body: [
          "grant_type": "client_credentials",
          "scope": "public"
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
      throw AuthError.internalError("Unable to parse reponse: \(error.localizedDescription)")
    }
  }
  
  // MARK: - Private
  private static let authPath = "oauth/authorize/client"
  
  private func decodeError(from data: Data) -> String? {
    // TODO: implement better network parsing
    String(data: data, encoding: .utf8)
  }
}
