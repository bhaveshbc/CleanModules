//
//  MovieListEndPoint.swift
//  CleanModules
// https://api.themoviedb.org/3/tv/200875?api_key=06e1a8c1f39b7a033e2efb972625fee2&language=en
//  Created by Bhavesh Chaudhari on 14/11/25.

import APIClient

enum MovieListEndPoint: EndPointType {
   
    case todayMovies(param: ParamType)
    case popularMovies(param: ParamType)
    case movieDetails(movieid: Int, param: ParamType)
    
    var domainName: String {
        return "https://api.themoviedb.org"
    }
    
    var path: String {
        switch self {
        case .todayMovies:
            return "/3/tv/airing_today"
        case .popularMovies:
            return "/3/tv/popular"
        case .movieDetails(let movieId, _ ):
            return "/3/tv/\(movieId)"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .todayMovies(let paramType), .popularMovies(let paramType):
            return .requestParameters(bodyParameters: paramType)
        case .movieDetails( _ , let paramType):
            return .requestParameters(bodyParameters: paramType)
        }
    }
}
