//
//  DashboardViewModel.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/26/24.
//  Updated 2025-09-27.
//

import SwiftUI

@MainActor
class DashboardViewModel: ObservableObject {
    // Filter is server-side: when it changes, trigger a fetch for page 1.
    @Published var filter: ActivityType? = nil {
        didSet {
            // When filter changes, reset paging and fetch server-side filtered list.
            currentPage = 1
            Task { await fetchActivities(page: currentPage) }
        }
    }

    // Published list of activities used by the UI (already filtered & sorted by VM).
    @Published private(set) var activities: [Activity] = [] {
        didSet {
            calculateNextFeedingTime()
            calculateFeedingAmount()
        }
    }

    @Published var nextFeedingTime = Date()
    @Published var todayFeedingAmount: Double = 0
    @Published var isLoading = false
    @Published var errorMessage: IdentifiableError? = nil

    private let repository: ActivityRepositoryProtocol
    private var allActivities: [Activity] = []

    private var currentPage = 1
    private let pageSize = 10

    init(repository: ActivityRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Public API

    func deleteActivities(at indexSet: IndexSet) async {
        // activities is already sorted and displayed order is the same
        let toDelete = indexSet.compactMap { idx -> Activity? in
            guard idx >= 0 && idx < activities.count else { return nil }
            return activities[idx]
        }

        guard !toDelete.isEmpty else { return }

        do {
            try await withThrowingTaskGroup(of: Void.self) { group in
                for activity in toDelete {
                    group.addTask {
                        try await self.repository.deleteActivity(activityToDelete: activity)
                    }
                }
                try await group.waitForAll()
            }
            // single refresh after batch delete
            await refreshActivities()
        } catch {
            errorMessage = IdentifiableError(
                message: "Failed to remove activity: \(error.localizedDescription)"
            )
        }
    }

    /// Fetch activities. If page is nil, uses currentPage.
    func fetchActivities(page: Int? = nil) async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        let pageToFetch = page ?? currentPage

        do {
            // repository supports optional server-side filter
            let result = try await repository.fetchActivities(page: pageToFetch, pageSize: pageSize, filter: filter)
            if pageToFetch == 1 {
                allActivities = result.results
            } else {
                // append unique ones
                let newActivities = result.results.filter { newActivity in
                    !allActivities.contains { $0.id == newActivity.id }
                }
                allActivities.append(contentsOf: newActivities)
            }

            // Keep currentPage consistent with successful fetch
            currentPage = pageToFetch

            // Apply sorting and update published activities
            applyFilterAndSort()
        } catch {
            errorMessage = IdentifiableError(
                message: "Failed to load activities: \(error.localizedDescription)"
            )
        }
    }

    func refreshActivities() async {
        currentPage = 1
        await fetchActivities(page: currentPage)
    }

    // MARK: - Private helpers

    /// Because filtering is done server-side we still may want to sort and expose activities in a predictable order.
    private func applyFilterAndSort() {
        // allActivities are assumed to reflect server filter when fetch uses `filter` param.
        let sorted = allActivities.sorted(by: { $0.startTime > $1.startTime })
        activities = sorted
    }

    private func calculateNextFeedingTime() {
        let lastFeeding = activities.first(where: { $0.type == .feed })
        // If last feeding exists, add the configured interval. Otherwise fallback to Date()
        nextFeedingTime = lastFeeding?.startTime.addingTimeInterval(Config.feedingInteravalInMinutes * 60) ?? Date()
    }

    private func calculateFeedingAmount() {
        todayFeedingAmount = activities
            .filter { Calendar.current.isDateInToday($0.startTime) && $0.type == .feed }
            .map { $0.amount ?? 0 }
            .reduce(0, +)
    }
}
