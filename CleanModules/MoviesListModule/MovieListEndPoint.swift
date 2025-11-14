//
//  MovieListEndPoint.swift
//  CleanModules
//
//  Created by Bhavesh Chaudhari on 14/11/25.

import APIClient

enum MovieListEndPoint: EndPointType {
   
    case todayMovies(param: ParamType)
    case popularMovies(param: ParamType)
    
    var domainName: String {
        return "https://api.themoviedb.org"
    }
    
    var path: String {
        switch self {
        case .todayMovies:
            return "/3/tv/airing_today"
        case .popularMovies:
            return "/3/tv/popular"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .todayMovies(let paramType), .popularMovies(let paramType):
            return .requestParameters(bodyParameters: paramType)
        }
    }
}
