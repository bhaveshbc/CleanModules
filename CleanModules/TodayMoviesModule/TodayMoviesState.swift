//
//  TodayMoviesState.swift
//  CleanModules
//
//  Created by Bhavesh Chaudhari on 14/11/25.
//
import ModelsKit
import Foundation
struct TodayMoviesListState {
    
    var movies: [TVShow2DTO] = []
    var pageIndex: Int = 1
    var totalCount: Int = 0
    var isIntialLoading: Bool = false
    var isPagningNating: Bool = false
    var error: String?
    
    var isEmpty: Bool {
        movies.isEmpty && !isIntialLoading
    }
    
    var shouldLoadMore: Bool {
        movies.count < totalCount
    }
    
    enum DisplayState: Equatable {
        case loading
        case loaded([TVShow2DTO])
        case paginating([TVShow2DTO])
        case empty(String)
        case error(String)
    }
    
    var displayState: DisplayState {
        if isIntialLoading && movies.isEmpty {
            return .loading
        } else if let error = error, movies.isEmpty {
            return .error(error)
        } else if isEmpty {
            return .empty("No new notifications")
        } else if isPagningNating {
            return .paginating(movies)
        } else {
            return .loaded(movies)
        }
    }
}

enum TodayMoviesListAction {
    case startLoading(isInitial: Bool)
    case loadSuccess(notifications: [TVShow2DTO], totalCount: Int)
    case loadFailure(error: String)
    case reset
    case incrementPage
}

func reduce(state: TodayMoviesListState, action: TodayMoviesListAction) -> TodayMoviesListState {
    var newState = state
    
    switch action {
    case .startLoading(let isInitial):
        newState.isIntialLoading = isInitial
        newState.isPagningNating = !isInitial
        newState.error = nil
        
    case .loadSuccess(let movies, let totalCount):
        newState.movies.append(contentsOf: movies)
        newState.totalCount = totalCount
        newState.isIntialLoading = false
        newState.isPagningNating = false
        
    case .loadFailure(let error):
        newState.error = error
        newState.isIntialLoading = false
        newState.isPagningNating = false
        
    case .reset:
        newState.movies.removeAll()
        newState.pageIndex = 1
        newState.error = nil
        
    case .incrementPage:
        newState.pageIndex += 1
    }
    
    return newState
}

struct MovieListAction {
    let onRefresh: () async -> Void
    let onLoadMore: (Int, Int) async -> Void
}
