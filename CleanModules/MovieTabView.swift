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
            
            TodayMovieTabView(apiService: diObject.todayApiService)
            .tabItem { Label("Today", systemImage: "calendar.badge.clock") }
            .tag(0)

            PopularMovieTabView(apiService: diObject.todayApiService)
            .tabItem { Label("Popular", systemImage: "star.fill") }
            .tag(1)
        }
    }
}


struct TodayMovieTabView: View {
    
    let store: MovieListStore
    @State var path = NavigationPath()
    
    init(apiService: MoviesListApiServiceProtocol) {
        self.store = .init(service: apiService)
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            MoviesListView(movieStore: store)
            .navigationTitle("Today Movies")
        }.onChange(of: store.state.selectedMovie) {
            if let movie = store.state.selectedMovie {
                    path.append(movie)
                    store.resetMoveieSelection()
                }
        }
    }
}


struct PopularMovieTabView: View {
    
    let store: MovieListStore
    @State var path = NavigationPath()
    
    init(apiService: MoviesListApiServiceProtocol) {
        self.store = .init(service: apiService)
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            MoviesListView(movieStore: store)
                .navigationTitle("Popular Movies")
        }.onChange(of: store.state.selectedMovie) {
            if let movie = store.state.selectedMovie {
                    path.append(movie)
                    store.resetMoveieSelection()
                }
        }

    }
}

