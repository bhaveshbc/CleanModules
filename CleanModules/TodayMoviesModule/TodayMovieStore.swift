//
//  TodayMovieStore.swift
//  CleanModules
//
//  Created by Bhavesh Chaudhari on 14/11/25.
//
import Foundation
import SwiftUI
@propertyWrapper
struct TodayMovieStore: DynamicProperty {
    
    @State var state:TodayMoviesListState = .init()
    let service: TodayMoviesApiServiceProtocol
    
    init(service: TodayMoviesApiServiceProtocol) {
        self.service = service
    }

    var wrappedValue:TodayMoviesListState {
        return state
    }
    
    var projectedValue: TodayMovieStoreProjection {
        TodayMovieStoreProjection(state: state, actions: .init(onRefresh: handleRefresh, onLoadMore: loadMore))
    }
    
    private func handleRefresh() async {
        state = reduce(state: state, action: .reset)
        await performLoad()
    }
    
    private func loadMore(currentIndex: Int, loadedMovieCout: Int) async {
        
        guard state.shouldLoadMore else { return }
        guard currentIndex == loadedMovieCout - 1 else { return }
        guard !state.isPagningNating else { return }
        
        state = reduce(state: state, action: .incrementPage)
        await performLoad()
    }
    
    private func performLoad() async {
        guard !state.isIntialLoading else { return }
        
        let isInitial = state.movies.isEmpty
        state = reduce(state: state, action: .startLoading(isInitial: isInitial))
        
        do {
            let response = try await service.fetchMovieList(pageIndex: state.pageIndex)
            state = reduce(
                state: state,
                action: .loadSuccess(
                    notifications: response.showsList,
                    totalCount: response.totalShows
                )
            )
        } catch {
            state = reduce(state: state, action: .loadFailure(error: error.localizedDescription))
        }
    }
    
}

struct TodayMovieStoreProjection {
    let state: TodayMoviesListState
    let actions: MovieListAction
}
