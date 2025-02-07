//
//  BjayApp.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/25/24.
//

import SwiftUI

@main
struct BjayApp: App {
    let repository: ActivityRepositoryProtocol = ActivityRepository()
    
    var body: some Scene {
        WindowGroup {
            let coordinator = NavigationCoordinator(repository: repository)
            coordinator.createDashboardView()
        }
    }
}
