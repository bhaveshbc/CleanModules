//
//  TodayMoviesEndPoint.swift
//  CleanModules
//
//  Created by Bhavesh Chaudhari on 14/11/25.
// https://api.themoviedb.org/3/tv/airing_today?page=1&language=en&api_key=06e1a8c1f39b7a033e2efb972625fee2

import APIClient

enum TodayMoviesEndPoint: EndPointType {
   
    case todayMovies(param: ParamType)
    
    var domainName: String {
        return "https://api.themoviedb.org"
    }
    
    var path: String {
        switch self {
        case .todayMovies:
            return "/3/tv/airing_today"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .todayMovies(let paramType):
            return .requestParameters(bodyParameters: paramType)
        }
    }
}
