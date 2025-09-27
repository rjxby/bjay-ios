//
//  BjayApp.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/25/24.
//

import SwiftUI

@main
struct BjayApp: App {
    let repository = ActivityRepository()

    var body: some Scene {
        let coordinator = NavigationCoordinator()

        coordinator.makeFeedView = {
            FeedView(viewModel: FeedViewModel(repository: repository), coordinator: coordinator)
        }
        coordinator.makeSleepView = {
            SleepView(viewModel: SleepViewModel(repository: repository), coordinator: coordinator)
        }
        coordinator.makeDiaperView = {
            DiaperView(viewModel: DiaperViewModel(repository: repository), coordinator: coordinator)
        }
        coordinator.makeActivityTypeSelectionView = {
            ActivityTypeSelectionView(coordinator: coordinator)
        }

        return WindowGroup {
            DashboardView(
                viewModel: DashboardViewModel(repository: repository),
                coordinator: coordinator
            )
        }
    }
}
