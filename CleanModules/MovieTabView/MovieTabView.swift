//
//  MovieTabView.swift
//  CleanModules
//
//  Created by Bhavesh Chaudhari on 14/11/25.
//
import SwiftUI
import APIClient
import ModelsKit

struct MovieTabView: View {
    
    @State private var selectedTab = 0
    
    @Environment(DIContainer.self) var diObject

    var body: some View {
        TabView(selection: $selectedTab) {
            
            TodayMovieTabView(apiService: diObject.todayApiService)
            .tabItem { Label("Today", systemImage: "calendar.badge.clock") }
            .tag(0)

            PopularMovieTabView(apiService: diObject.todayApiService)
            .tabItem { Label("Popular", systemImage: "star.fill") }
            .tag(1)
        }
    }
}




