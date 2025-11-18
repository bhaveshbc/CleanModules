//
//  MovieList.swift
//  CleanModules
//
//  Created by Bhavesh Chaudhari on 10/11/25.
//
import SwiftUI
import ModelsKit
struct ShowRowView: View {
    
    let show: TVShow2DTO
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: "\(imagePath)\(show.posterPath ?? "")")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 100, height: 140)
            .cornerRadius(12)
            .clipped()
            
            VStack(alignment: .leading, spacing: 6) {
                Text(show.name)
                    .font(.headline)
                
                Text(show.firstAirDate ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("⭐️ \(String(format: "%.1f", show.voteAverage))")
                    Text("• US")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Text(show.overview)
                    .font(.footnote)
                    .foregroundColor(.primary)
                    .lineLimit(3)
            }
            Spacer()
        }.frame(maxWidth: .infinity)
            .padding( 8).background((Color.gray.opacity(0.1)))
            .cornerRadius(12)
            .shadow(color: Color.primary.opacity(0.15), radius: 8, x: 4, y: 4)
    }
}


