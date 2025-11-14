//
//  ContentView.swift
//  CleanModules
//
//  Created by Bhavesh Chaudhari on 10/11/25.
//

import SwiftUI
import APIClient

struct ContentView: View {
    
    var body: some View {
        TodayMoviesView(todayMovieStore: .init(service: TodayMoviesApiService(router: NetWorkClient())))
    }
}

#Preview {
    ContentView()
}
