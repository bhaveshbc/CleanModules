//
//  MovieDetailView.swift
//  CleanModules
//
//  Created by Bhavesh Chaudhari on 17/11/25.
//
import SwiftUI
import ModelsKit
import DesignKit

struct MovieDetailView: View {
    
    @State private var store: MoveDetailStore
    private enum CoordinateSpaces {
            case scrollView
        }
    
    init(store: MoveDetailStore) {
        self.store = store
    }
    
    var body: some View {
        VStack {
            switch store.state.displayState {
            case .loading:
                LoadingView(loaderColor: .goldenYellow)
            case .loaded(let tVShowDetailDTO):
                scrollView(for: tVShowDetailDTO)
            case .loadFailure(let error):
                EmptyStateView(message: error)
            }
        }.toolbar(.hidden, for: .tabBar).task(id: false) {
             store.fetchMoveDetail()
        }
    }
    
    func scrollView(for movie: TVShowDetailDTO) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: Top Image
                ParallaxHeader(coordinateSpace: CoordinateSpaces.scrollView, defaultHeight: 400, {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w780\(movie.backdropPath ?? "")")) { img in
                        img
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                })
    
                VStack(alignment: .leading, spacing: 16) {
               
                    // MARK: Title & Tagline
                    HStack(alignment: .center) {

                        VStack( spacing: 0) {
                            Text(movie.name ?? "")
                                .font(.largeTitle.bold())
                            
                            if let tagline = movie.tagline, !tagline.isEmpty {
                                Text(tagline)
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }
                        }.frame(maxWidth: .infinity, alignment: .center)

                        if let voteCount = movie.voteCount, let voteAverage = movie.voteAverage {
                            CircularRatingView(rating: voteAverage, totalVotes: voteCount).padding(.horizontal)
                        }

                    }.padding()
                    
                    
                    // MARK: Genres
                    if !movie.genres.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(movie.genres, id: \.id) { genre in
                                    Text(genre.name)
                                        .font(.subheadline)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color.blue.opacity(0.15))
                                        .clipShape(Capsule())
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // MARK: Overview
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Overview")
                            .font(.title3.bold())
                        
                        Text(movie.overview ?? "")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    
                    // MARK: Creator Section
                    if !movie.createdBy.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Created By")
                                .font(.title3.bold())

                            ForEach(movie.createdBy, id: \.id) { creator in
                                HStack(spacing: 12) {
                                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w185\(creator.profilePath ?? "")")) { img in
                                        img.resizable().scaledToFill()
                                    } placeholder: {
                                        Color.gray.opacity(0.2)
                                    }
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())

                                    VStack(alignment: .leading) {
                                        Text(creator.name)
                                            .font(.headline)
                                        Text("ID: \(creator.id)")
                                            .foregroundColor(.secondary)
                                            .font(.subheadline)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // MARK: Next & Last Episodes
                    if let last = movie.lastEpisodeToAir {
                        episodeSection(title: "Last Episode", ep: last)
                    }

                    if let next = movie.nextEpisodeToAir {
                        episodeSection(title: "Next Episode", ep: next)
                    }
                    
                    Spacer().frame(height: 20)
                    
                }.frame(maxWidth: .infinity).background(Color.stackBG)
            }
        }.coordinateSpace(name: CoordinateSpaces.scrollView)
        .ignoresSafeArea(edges: .top)

    }
    
    // MARK: Episode Card Section
    @ViewBuilder
    private func episodeSection(title: String, ep: EpisodeDTO) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3.bold())
            
            VStack(alignment: .leading, spacing: 6) {
                Text(ep.name)
                    .font(.headline)
                
                Text(ep.overview)
                    .foregroundColor(.secondary)
                HStack {
                    if let date = ep.airDate, !date.isEmpty {
                        Text("Air Date: \(date)")
                    }
                    if let runtime = ep.runtime, runtime > 0 {
                        Text("Runtime: \(runtime) min")
                    }
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal)
    }
}


