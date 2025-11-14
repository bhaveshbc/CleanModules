//
//  MovieTabView.swift
//  CleanModules
//
//  Created by Bhavesh Chaudhari on 14/11/25.
//
import SwiftUI
import APIClient

struct MovieTabView: View {
    
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            
            NavigationStack {
                MoviesListView(movieStore: .init(service: TodayMoviesApiService(router: NetWorkClient())))
                .navigationTitle("Today Movies")
            }
            .tabItem { Label("Today", systemImage: "calendar.badge.clock") }
            .tag(0)

            NavigationStack {
                MoviesListView(movieStore: .init(service: PopularMoviesApiService(router: NetWorkClient())))
                    .navigationTitle("Popular Movies")
            }
            .tabItem { Label("Popular", systemImage: "star.fill") }
            .tag(1)
        }
    }
}
