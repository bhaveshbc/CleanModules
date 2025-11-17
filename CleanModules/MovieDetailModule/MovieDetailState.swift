//
//  MovieDetailState.swift
//  CleanModules
//
//  Created by Bhavesh Chaudhari on 17/11/25.
//

import ModelsKit

struct MovieDetailState {
    
    var movieDetail: TVShowDetailDTO?
    var error: String?
    
    var displayState: DisplayState {
        if let movieDetail = movieDetail {
            return .loaded(movieDetail)
        } else if let error = error {
            return .loadFailure(error: error)
        } else {
            return .loading
        }
    }
    
    enum DisplayState {
        case loading
        case loaded(TVShowDetailDTO)
        case loadFailure(error: String)
    }
}

enum MovieDetailAction {
    case startLoading
    case loadSuccess(TVShowDetailDTO)
    case loadFailure(error: String)
    case reset
}

func reduce(state: MovieDetailState, action: MovieDetailAction) -> MovieDetailState  {
    var newState = state
    switch action {
    case .startLoading:
        newState.movieDetail = nil
        newState.error = nil
    case .loadSuccess(let movieDetail):
        newState.movieDetail = movieDetail
        newState.error = nil
    case .loadFailure(let error):
        newState.movieDetail = nil
        newState.error = error
    case .reset:
        newState.movieDetail = nil
        newState.error = nil
    }
    return newState
}
