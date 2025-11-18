//
//  TodayMovieStore.swift
//  CleanModules
//
//  Created by Bhavesh Chaudhari on 14/11/25.
//
import Foundation
import SwiftUI
import ModelsKit

@propertyWrapper
struct MovieListStore: DynamicProperty {
    
    @State var state:MoviesListState = .init()
    @State  var currentTask: Task<Void, Never>?
    
    let service: MoviesListApiServiceProtocol
    
    init(service: MoviesListApiServiceProtocol) {
        self.service = service
    }
    
    var wrappedValue:MoviesListState {
        return state
    }
    
    @MainActor
    var projectedValue: TodayMovieStoreProjection {
        TodayMovieStoreProjection(state: state, actions: .init(onRefresh: handleRefresh, onLoadMore: loadMore, onTapMovie: onTapMovie))
    }
    
    @MainActor
    private func handleRefresh() async {
        currentTask?.cancel()
        currentTask = nil
        
        state = reduce(state: state, action: .reset)
        
        await performLoad()
    }
    
    @MainActor
    func onTapMovie(_ movie: TVShow2DTO) {
        state = reduce(state: state, action: .movieSelected(movie))
    }
    
    @MainActor
    func resetMoveieSelection() {
        state = reduce(state: state, action: .movieSelected(nil))
    }
    
    @MainActor
    private func loadMore(currentIndex: Int, loadedMovieCout: Int) async {
        
        guard state.shouldLoadMore else { return }
        guard currentIndex == loadedMovieCout - 1 else { return }
        guard !state.isPagningNating else { return }
        
        state = reduce(state: state, action: .incrementPage)
        await performLoad()
    }
    
    @MainActor
    private func performLoad() async {
        guard !state.isIntialLoading && !state.isPagningNating else {
            return
        }
        
        let isInitial = state.movies.isEmpty
        state = reduce(state: state, action: .startLoading(isInitial: isInitial))
        
        currentTask = Task {
            do {
                let response = try await service.fetchMovieList(pageIndex: state.pageIndex)
                try Task.checkCancellation()
                state = reduce(
                    state: state,
                    action: .loadSuccess(
                        notifications: response.showsList,
                        totalCount: response.totalShows
                    )
                )
            } catch is CancellationError {
                return
            } catch {
                if !Task.isCancelled {
                    state = reduce(state: state, action: .loadFailure(error: error.localizedDescription))
                }
            }
        }
        
    
        await currentTask?.value
    }
    
}

struct TodayMovieStoreProjection {
    let state: MoviesListState
    let actions: MovieListAction
}
