//
//  DIContainer.swift
//  CleanModules
//
//  Created by Bhavesh Chaudhari on 17/11/25.
//

import Foundation
import APIClient
import SwiftUI

@Observable
final class DIContainer {
    
    let networkClient = NetWorkClient()

    @ObservationIgnored
    lazy var todayApiService: MoviesListApiServiceProtocol = TodayMoviesApiService(router: networkClient)
    @ObservationIgnored
    lazy var popularApiService: MoviesListApiServiceProtocol = PopularMoviesApiService(router: networkClient)
}
