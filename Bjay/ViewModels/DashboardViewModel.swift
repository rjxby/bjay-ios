//
//  DashboardViewModel.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/26/24.
//

import SwiftUI

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var filter: ActivityType? = nil {
        didSet {
            Task {
                await refreshActivities()
                
                if let filterValue = filter {
                    activities = activities.filter({ $0.type == filterValue})
                }
            }
        }
    }
    @Published var activities: [Activity] = [] {
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

    private var currentPage = 1
    private let pageSize = 10

    init(repository: ActivityRepositoryProtocol) {
        self.repository = repository
    }

    /// Deletes activities at the specified indices.
    func deleteActivities(at indexSet: IndexSet) async {
        let sortedActivities = activities.sorted(by: { $0.startTime > $1.startTime })
        
        for index in indexSet {
            let activityToDelete = sortedActivities[index]
            do {
                try await repository.deleteActivity(activityToDelete: activityToDelete)
                let activitiesResult = try await repository.fetchActivities(page: currentPage, pageSize: pageSize)
                withAnimation {
                    activities = activitiesResult.results
                }
            } catch {
                errorMessage = IdentifiableError(message: "Failed to remove activity: \(error.localizedDescription)")
                break
            }
        }
    }

    /// Fetches activities from the repository and updates the local cache.
    func fetchActivities(page: Int, pageSize: Int, filter: ActivityType? = nil) async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let activitiesResult = try await repository.fetchActivities(page: page, pageSize: pageSize)
            withAnimation(.easeInOut) {
                activities = activitiesResult.results
            }
        } catch {
            errorMessage = IdentifiableError(message: "Failed to load activities: \(error.localizedDescription)")
        }
    }

    /// Refreshes all activities from the start.
    func refreshActivities() async {
        currentPage = 1
        await fetchActivities(page: currentPage, pageSize: pageSize)
    }

    /// Calculates the next feeding time based on the most recent feeding activity.
    private func calculateNextFeedingTime() {
        let lastFeeding = activities
            .sorted(by: { $0.startTime > $1.startTime })
            .first(where: { $0.type == .feed })

        nextFeedingTime = lastFeeding?.startTime.addingTimeInterval(Config.feedingInteravalInMinutes * 60) ?? Date()
    }
    
    /// Calculates feeding amount based on the current date.
    private func calculateFeedingAmount() {
        todayFeedingAmount = activities
            .filter({ Calendar.current.isDateInToday($0.startTime) && $0.type == .feed })
            .map({ $0.amount ?? 0 })
            .reduce(0, +)
    }
}
