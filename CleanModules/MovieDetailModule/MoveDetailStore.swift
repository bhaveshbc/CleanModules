//
//  MoveDetailStore.swift
//  CleanModules
//
//  Created by Bhavesh Chaudhari on 17/11/25.
//

import SwiftUI
import ModelsKit

@MainActor
@Observable
final class MoveDetailStore {
    
    var state =  MovieDetailState()
    var currentTask: Task<Void, Never>?
    let service: MovieDetailApiServiceProtocol
    let selectedMovie: TVShow2DTO

    init(service: MovieDetailApiServiceProtocol, selectedMovie: TVShow2DTO) {
        self.service = service
        self.selectedMovie = selectedMovie
    }
    
    func fetchMoveDetail()  {
        state = reduce(state: state, action: .startLoading)
        Task {
            await makeApiRequestForMovieDetail()
        }
    }

    private func makeApiRequestForMovieDetail() async {
        currentTask = Task {
            do {
                let response = try await service.fetchMovieDetail(movieId: selectedMovie.id)
                try Task.checkCancellation()
                state = reduce(state: state, action: .loadSuccess(response))
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
        await currentTask?.value
    }
    
    
}
