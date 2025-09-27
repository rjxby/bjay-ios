//
//  NavigationCoordinator.swift
//  Bjay
//
//  Created by Vlad Kochin on 1/4/25.
//  Updated 2025-09-27.
//

import SwiftUI

final class NavigationCoordinator: ObservableObject {
    @Published var path: [Route] = []

    func popToRoot() {
        path.removeAll()
    }

    var makeFeedView: (() -> FeedView)?
    var makeSleepView: (() -> SleepView)?
    var makeDiaperView: (() -> DiaperView)?
    var makeActivityTypeSelectionView: (() -> ActivityTypeSelectionView)?
}
