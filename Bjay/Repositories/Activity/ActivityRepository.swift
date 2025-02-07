//
//  ActivityRepository.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/26/24.
//

import Foundation

@MainActor
class ActivityRepository: ActivityRepositoryProtocol {
    private(set) var activitiesCache: [Activity] = []
    private let activityService: ActivityServiceProtocol
    
    init(activityService: ActivityServiceProtocol = ActivityService()) {
        self.activityService = activityService
    }
    
    // MARK: - Fetch Activities
    func fetchActivities(page: Int, pageSize: Int) async throws -> PaginationResponse<Activity> {
        let response = try await activityService.fetchActivities(page: page, pageSize: pageSize)
        
        if page == 1 {
            // Reset cache when fetching first page
            activitiesCache = response.results
        } else {
            // For subsequent pages, append only new items
            let newActivities = response.results.filter { newActivity in
                !activitiesCache.contains { $0.id == newActivity.id }
            }
            activitiesCache.append(contentsOf: newActivities)
        }
        
        return response
    }
    
    // MARK: - Add Activity
    func addActivity(newActivity: NewActivity) async throws {
        let request = CreateActivityRequest(
            accountId: Config.accountId,
            type: newActivity.type,
            startTime: newActivity.startTime,
            endTime: newActivity.endTime,
            amount: newActivity.amount,
            meta: newActivity.meta
        )
        
        let createdActivity = try await activityService.addActivity(request: request)
        activitiesCache.insert(createdActivity, at: 0) // Add to the beginning since it's newest
    }
    
    // MARK: - Delete Activity
    func deleteActivity(activityToDelete: Activity) async throws {
        if try await activityService.deleteActivity(id: activityToDelete.id) {
            activitiesCache.removeAll { $0.id == activityToDelete.id }
        } else {
            throw RepositoryError.deletionFailed
        }
    }
    
    // MARK: - Cache Management
    func clearCache() {
        activitiesCache.removeAll()
    }
    
    func refreshCache() async throws {
        _ = try await fetchActivities(page: 1, pageSize: activitiesCache.count + 1)
    }
}

// MARK: - Repository Errors
enum RepositoryError: LocalizedError {
    case deletionFailed
    case invalidCache
    
    var errorDescription: String? {
        switch self {
        case .deletionFailed:
            return "Failed to delete activity"
        case .invalidCache:
            return "Cache state is invalid"
        }
    }
}
