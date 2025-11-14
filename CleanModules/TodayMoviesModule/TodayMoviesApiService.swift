//
//  TodayMoviesApiService.swift
//  CleanModules
//
//  Created by Bhavesh Chaudhari on 14/11/25.
//
import ModelsKit
import APIClient
import Foundation

protocol TodayMoviesApiServiceProtocol {
    func fetchMovieList(pageIndex: Int) async throws -> TVShowPageDTO
}

// MARK: - Service Implementation
struct TodayMoviesApiService: TodayMoviesApiServiceProtocol {
    
    let router: Networkable
    
    func fetchMovieList(pageIndex: Int) async throws -> TVShowPageDTO {
        let param: [String: String] = ["page": "\(pageIndex)", "language": "en", "api_key": "06e1a8c1f39b7a033e2efb972625fee2"]
        let endpoint: TodayMoviesEndPoint = .todayMovies(param: .urlParam(model: param))
        let request: URLRequest = try RequestBuilder().buildRequest(from: endpoint)
        return try await router.request(request: request)
    }
}
