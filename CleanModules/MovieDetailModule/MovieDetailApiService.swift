//
//  MovieDetailApiService.swift
//  CleanModules
//
//  Created by Bhavesh Chaudhari on 17/11/25.
//
import ModelsKit
import APIClient
import Foundation

protocol MovieDetailApiServiceProtocol: Sendable {
    func fetchMovieDetail(movieId: Int) async throws -> TVShowDetailDTO
}

// MARK: - Service Implementation
struct MovieDetailApiService: MovieDetailApiServiceProtocol {
    
    let router: Networkable
    
    func fetchMovieDetail(movieId: Int) async throws -> TVShowDetailDTO {
        let param: [String: String] = [ "language": "en", "api_key": "06e1a8c1f39b7a033e2efb972625fee2"]
        let endpoint: MovieListEndPoint = .movieDetails(movieid: movieId, param: .urlParam(model: param))
        let request: URLRequest = try RequestBuilder().buildRequest(from: endpoint)
        print(request.curl)
        return try await router.request(request: request)
    }
}
