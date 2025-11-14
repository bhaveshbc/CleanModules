//
//  TodayMovieStore.swift
//  CleanModules
//
//  Created by Bhavesh Chaudhari on 14/11/25.
//
import Foundation
import SwiftUI
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

    var projectedValue: TodayMovieStoreProjection {
        TodayMovieStoreProjection(state: state, actions: .init(onRefresh: handleRefresh, onLoadMore: loadMore))
    }
    
    private func handleRefresh() async {
        await Task.detached { @MainActor in
            // Cancel any existing task before starting new one
            currentTask?.cancel()
            currentTask = nil
            // Reset state
            state = reduce(state: state, action: .reset)
            
            await performLoad()
        }.value
    }
    
    private func loadMore(currentIndex: Int, loadedMovieCout: Int) async {
        
        guard state.shouldLoadMore else { return }
        guard currentIndex == loadedMovieCout - 1 else { return }
        guard !state.isPagningNating else { return }
        
        state = reduce(state: state, action: .incrementPage)
        await performLoad()
    }
    
    private func performLoad() async {
        guard !state.isIntialLoading && !state.isPagningNating else {
            print(" Request already in progress, skipping")
            return
        }
        
        let isInitial = state.movies.isEmpty
        state = reduce(state: state, action: .startLoading(isInitial: isInitial))
        
        let task = Task { @MainActor in
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
                print("Task was cancelled (expected behavior)")
                return
            } catch {
                if !Task.isCancelled {
                    print("Error loading notifications: \(error.localizedDescription)")
                    state = reduce(state: state, action: .loadFailure(error: error.localizedDescription))
                }
            }
        }
        
       currentTask = task
        await task.value
    }
    
}

struct TodayMovieStoreProjection {
    let state: MoviesListState
    let actions: MovieListAction
}
