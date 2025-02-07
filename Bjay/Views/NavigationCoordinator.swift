//
//  NavigationCoordinator.swift
//  Bjay
//
//  Created by Vlad Kochin on 1/4/25.
//

import SwiftUI

final class NavigationCoordinator: ObservableObject {
    @Published var path: [Route] = []
    private let repository: ActivityRepositoryProtocol
    
    init(repository: ActivityRepositoryProtocol) {
        self.repository = repository
    }
    
    func popToRoot() {
        path.removeAll()
    }
    
    // Factory methods for views
    @MainActor func createDashboardView() -> DashboardView {
        DashboardView(
            viewModel: DashboardViewModel(repository: repository),
            coordinator: self
        )
    }
    
    @MainActor func createFeedView() -> FeedView {
        FeedView(viewModel: FeedViewModel(repository: repository))
    }
    
    @MainActor func createSleepView() -> SleepView {
        SleepView(viewModel: SleepViewModel(repository: repository))
    }
    
    @MainActor func createDiaperView() -> DiaperView {
        DiaperView(viewModel: DiaperViewModel(repository: repository))
    }
    
    @MainActor func createActivityTypeSelectionView() -> ActivityTypeSelectionView {
        ActivityTypeSelectionView()
    }
}
