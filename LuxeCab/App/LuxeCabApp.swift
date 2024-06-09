//
//  LuxeCabApp.swift
//  LuxeCab
//
//  Created by JJMac on 08/06/24.
//

import SwiftUI

@main
struct LuxeCabApp: App {
    @StateObject var locationViewModel = LocationSearchViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationViewModel)
        }
    }
}
