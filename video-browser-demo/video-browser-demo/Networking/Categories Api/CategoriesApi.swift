//
//  CategoriesApi.swift
//  video-browser-demo
//
//  Created by Anastasia Yurok on 04.12.2023.
//

import Foundation

enum CategoriesApiError: Error {
  // Auth failure
  case notAuthenticated
  // Unable to parse response
  case responseParsingFailure(String)
}

protocol CategoriesApi {
  // Retrieves videos for certain category
  func getVideosOfCategory(named name: String) async throws -> [Video]
}

class CategoriesApiImpl: CategoriesApi {
  let client: HTTPClient
  let authController: AuthController
  
  init(
    client: HTTPClient,
    authController: AuthController
  ) {
    self.client = client
    self.authController = authController
  }
  
  func getVideosOfCategory(named name: String) async throws -> [Video] {
    let authToken = try await getAuthToken()
    let data = try await client.data(
      with: "categories/\(name)/videos",
      query: [
        // TODO: implement pagination
        .init(name: "page", value: "1"),
        .init(name: "per_page", value: "50")
      ],
      method: "GET",
      authHeader: authToken.authorizationHeader,
      headers: [:],
      body: nil
    )
    
    do {
      let response = try JSONDecoder().decode(VideosResponse.self, from: data)
      return response.data
    } catch {
      throw AuthError.responseParsingFailure(error.localizedDescription)
    }
  }
  
  func getAuthToken() async throws -> AuthToken {
    if let token = authController.token {
      return token
    }
    
    do {
      try await authController.authenticate()
    } catch {
      throw CategoriesApiError.notAuthenticated
    }
    
    guard let authToken = authController.token else {
      throw CategoriesApiError.notAuthenticated
    }
    
    return authToken
  }
}
