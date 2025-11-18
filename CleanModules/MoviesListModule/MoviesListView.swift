//
//  MoviesListView.swift
//  CleanModules
//
//  Created by Bhavesh Chaudhari on 14/11/25.
//

import SwiftUI
import DesignKit
import ModelsKit

struct MoviesListView: View {
    
    @MovieListStore var movieStore: MoviesListState
    @Environment(DIContainer.self) var diObject
    
    var body: some View {
        
        let _ = Self._printChanges()
        VStack {
            switch $movieStore.state.displayState {
            case .loading:
                LoadingView(loaderColor: .goldenYellow)
            case .loaded(let movies), .paginating(let movies):
                MovieList(movies: movies, isPaginating: $movieStore.state.isPagningNating, onRefresh: $movieStore.actions.onRefresh, onLoadMore: $movieStore.actions.onLoadMore, onTapMovie: $movieStore.actions.onTapMovie)
            case .empty(let message), .error(let message):
                EmptyStateView(message: message)
            }
        }.task {
            await $movieStore.actions.onRefresh()
        }.navigationDestination(for: TVShow2DTO.self) { movie in
            let store = MoveDetailStore(service: diObject.movieDetailService, selectedMovie: movie)
            MovieDetailView(store: store)
        }

    }
}

struct MovieList: View {
    let movies: [TVShow2DTO]
    let isPaginating: Bool
    let onRefresh: () async -> Void
    let onLoadMore: (Int, Int) async -> Void
    let onTapMovie: (TVShow2DTO)  -> Void
    
    var body: some View {
        List {
            ForEach(movies.indices, id: \.self) { index in
                ShowRowView(show: movies[index])
                    .padding(.vertical, 10)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .onTapGesture {
                        onTapMovie(movies[index])
                    }
                    .onAppear {
                        Task {
                            await onLoadMore(index, movies.count)
                        }
                    }
            }
            
            if isPaginating {
                HStack {
                    Spacer()
                    BallPulseSync(ballSize: 20, ballColor: .goldenYellow)
                    Spacer()
                }
                .frame(height: 100)
                .listRowBackground(Color.clear)
            }
        }
        .refreshable {
            await onRefresh()
        }
        .padding(.horizontal, 16)
        .listStyle(.plain)
    }
}




