//
//  TodayMovieTabView.swift
//  CleanModules
//
//  Created by Bhavesh Chaudhari on 18/11/25.
//
import SwiftUI

struct TodayMovieTabView: View {
    
    let store: MovieListStore
    @State var path = NavigationPath()
    @Environment(DIContainer.self) var diObject
    
    init(apiService: MoviesListApiServiceProtocol) {
        self.store = .init(service: apiService)
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            MoviesListView(movieStore: store).environment(diObject)
            .navigationTitle("Today Movies")
        }.onChange(of: store.state.selectedMovie) {
            if let movie = store.state.selectedMovie {
                    path.append(movie)
                    store.resetMoveieSelection()
                }
        }
    }
}
