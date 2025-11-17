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
    
    @Environment(DIContainer.self) var diObject

    var body: some View {
        TabView(selection: $selectedTab) {
            
            NavigationStack {
                MoviesListView(movieStore: .init(service: diObject.todayApiService))
                .navigationTitle("Today Movies")
            }
            .tabItem { Label("Today", systemImage: "calendar.badge.clock") }
            .tag(0)

            NavigationStack {
                MoviesListView(movieStore: .init(service: diObject.popularApiService))
                    .navigationTitle("Popular Movies")
            }
            .tabItem { Label("Popular", systemImage: "star.fill") }
            .tag(1)
        }
    }
}
