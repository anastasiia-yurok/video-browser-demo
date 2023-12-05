//
//  CategoriesApi.swift
//  video-browser-demo
//
//  Created by Anastasia Yurok on 04.12.2023.
//

import Foundation

enum CategoriesApiError: Error {
  case notAuthenticated
  case internalError(String)
}

protocol CategoriesApi {
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
    if nil == authController.token {
      try await authController.authenticate()
    }
    
    guard let authToken = authController.token else {
      throw CategoriesApiError.notAuthenticated
    }
    
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
      throw CategoriesApiError.internalError(error.localizedDescription)
    }
  }
}
