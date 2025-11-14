//
//  TodayMoviesView.swift
//  CleanModules
//
//  Created by Bhavesh Chaudhari on 14/11/25.
//

import SwiftUI
import DesignKit
import ModelsKit

struct TodayMoviesView: View {
    
    @TodayMovieStore var todayMovieStore: TodayMoviesListState
    
    var body: some View {
        VStack {
            switch $todayMovieStore.state.displayState {
            case .loading:
                LoadingView(loaderColor: .goldenYellow)
            case .loaded(let movies), .paginating(let movies):
                MovieList(movies: movies, isPaginating: $todayMovieStore.state.isPagningNating, onRefresh: $todayMovieStore.actions.onRefresh, onLoadMore: $todayMovieStore.actions.onLoadMore)
            case .empty(let message), .error(let message):
                EmptyStateView(message: message)
            }
        }.task {
            Task {
                await $todayMovieStore.actions.onRefresh()
            }
        }
    }
}

struct MovieList: View {
    let movies: [TVShow2DTO]
    let isPaginating: Bool
    let onRefresh: () async -> Void
    let onLoadMore: (Int, Int) async -> Void
    
    var body: some View {
        List {
            ForEach(movies.indices, id: \.self) { index in
                ShowRowView(show: movies[index])
                    .padding(.vertical, 10)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
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







