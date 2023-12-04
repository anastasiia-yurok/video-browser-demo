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
  func getVideosOfCategory(named name: String) async throws -> VideosResponse // implement result
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
  
  func getVideosOfCategory(named name: String) async throws -> VideosResponse {
    guard let authToken = authController.token else {
      throw CategoriesApiError.notAuthenticated
    }
    
    let data = try await client.data(
      with: "categories/\(name)/videos",
      method: "GET",
      authHeader: authToken.authorizationHeader,
      headers: [:],
      body: nil
    )
    
    do {
      return try JSONDecoder().decode(VideosResponse.self, from: data)
    } catch {
      print(error.localizedDescription)
      throw CategoriesApiError.internalError(error.localizedDescription)
    }
  }
}
