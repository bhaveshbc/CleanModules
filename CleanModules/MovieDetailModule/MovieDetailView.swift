//
//  MovieDetailView.swift
//  CleanModules
//
//  Created by Bhavesh Chaudhari on 17/11/25.
//
import SwiftUI
import ModelsKit

struct MovieDetailView: View {
    
    let movie: TVShowDetailDTO
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: Top Image
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w780\(movie.backdropPath ?? "")")) { img in
                    img
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(height: 260)
                .clipped()
                
                // MARK: Title & Tagline
                VStack(alignment: .leading, spacing: 6) {
                    Text(movie.name ?? "")
                        .font(.largeTitle.bold())
                    
                    if let tagline = movie.tagline, !tagline.isEmpty {
                        Text(tagline)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                
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
            }
        }
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
                    Text("Air Date: \(ep.airDate)")
                    Spacer()
                    Text("Runtime: \(ep.runtime) min")
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


