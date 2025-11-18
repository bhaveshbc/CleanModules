//
//  MovieTabView.swift
//  CleanModules
//
//  Created by Bhavesh Chaudhari on 14/11/25.
//
import SwiftUI
import APIClient
import ModelsKit

struct MovieRootView: View {
    
    @Environment(DIContainer.self) var diObject
    
    var body: some View {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
            MovieTabView().environment(diObject)
        } else {
            MovieSidebarView().environment(diObject)
        }
        #else
        MovieSidebarView().environment(diObject)
        #endif
    }
}

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


struct MovieSidebarView: View {
    @Environment(DIContainer.self) var diObject
    @State private var selection: Int? = 0

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                Label("Today", systemImage: "calendar.badge.clock")
                    .tag(0)

                Label("Popular", systemImage: "star.fill")
                    .tag(1)
            }
        } detail: {
            switch selection {
            case 0:
                TodayMovieTabView(apiService: diObject.todayApiService)
            case 1:
                PopularMovieTabView(apiService: diObject.todayApiService)
            default:
                Text("Select a section")
            }
        }
    }
}




