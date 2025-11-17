//
//  CleanModulesApp.swift
//  CleanModules
//
//  Created by Bhavesh Chaudhari on 10/11/25.
//

import SwiftUI
import APIClient
@main
struct CleanModulesApp: App {
    
    let diObject: DIContainer = DIContainer()
    
    var body: some Scene {
        WindowGroup {
            MovieTabView().environment(diObject)
        }
    }
}
