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
        }.task(id: false) {
            await $movieStore.actions.onRefresh()
        }.navigationDestination(for: TVShow2DTO.self) { movie in
            MovieDetailView1(movie: movie)
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


struct MovieDetailView1: View {
    let movie: TVShow2DTO
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: "\(imagePath)\(movie.posterPath ?? "")")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(maxHeight: 400)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(movie.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text("⭐️ \(String(format: "%.1f", movie.voteAverage))")
                        Text("•")
                        Text(movie.firstAirDate ?? "")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    
                    Text("Overview")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    Text(movie.overview)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}




