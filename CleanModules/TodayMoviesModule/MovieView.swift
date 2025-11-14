//
//  MovieView.swift
//  CleanModules
//
//  Created by Bhavesh Chaudhari on 14/11/25.
//

import SwiftUI
import ModelsKit

struct MovieView: View {
    
    let show: TVShow2DTO

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Backdrop Image
                if let backdrop = show.backDropPath, let url = URL(string: "https://image.tmdb.org/t/p/w780" + backdrop) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 220)
                                .clipped()
                        default:
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 220)
                        }
                    }
                }

                // Title
                Text(show.name)
                    .font(.title)
                    .fontWeight(.bold)

                // Rating
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                    Text(String(format: "%.1f", show.voteAverage))
                    Text("(") + Text("\(show.voteCount)") + Text(") votes")
                }
                .foregroundColor(.yellow)
                .font(.subheadline)

                // Poster + Details
                HStack(alignment: .top, spacing: 16) {
                    if let poster = show.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w300" + poster) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120)
                                    .cornerRadius(12)
                            default:
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 120, height: 180)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        if let date = show.firstAirDate {
                            Text("First Aired: \(date)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        if let genres = show.genreIds {
                            Text("Genres: \(genres.map { String($0) }.joined(separator: ", "))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                // Overview
                Text("Overview")
                    .font(.headline)
                Text(show.overview)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationTitle(show.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct TVShow2View_Previews: PreviewProvider {
//    static var previews: some View {
//        TVShow2View(show: TVShow2DTO(
//            id: 52698,
//            name: "El Kabeer",
//            overview: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent vitae.",
//            firstAirDate: "2010-08-11",
//            posterPath: "/Ap86RyRhP7ikeRCpysnfC9PO2H0.jpg",
//            backDropPath: "/5dJccl3yF1Er6HVZDceYZC3rzhh.jpg",
//            genreIds: [35],
//            voteAverage: 7.3,
//            voteCount: 14
//        ))
//    }
//}
