//
//  ActivityRepositoryMock.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/29/24.
//

import Foundation

@MainActor
class ActivityRepositoryMock: ActivityRepositoryProtocol {
    private(set) var activitiesCache: [Activity] = []
    
    func fetchActivities(page: Int, pageSize: Int) async throws -> PaginationResponse<Activity> {
        let accountId = "71d085eb-ec61-4218-8ad5-5e9cf367f2b4"
        
        let results = [
            Activity(
                id: UUID().uuidString,
                accountId: accountId,
                type: .feed,
                startTime: Date(),
                endTime: nil,
                amount: 4.5,
                meta: nil
            ),
            Activity(
                id: UUID().uuidString,
                accountId: accountId,
                type: .sleep,
                startTime: Date().addingTimeInterval(-3600),
                endTime: Date(),
                amount: 1,
                meta: nil
            ),
            Activity(
                id: UUID().uuidString,
                accountId: accountId,
                type: .diaper,
                startTime: Date().addingTimeInterval(-7200),
                endTime: nil,
                amount: 1,
                meta: ActivityMeta.diaper(DiaperMeta(type: .wet))
            )
        ]
        
        if page == 1 {
            activitiesCache = results
        } else {
            activitiesCache.append(contentsOf: results)
        }
        
        return PaginationResponse<Activity>(page: page, limit: pageSize, size: results.count, results: results)
    }
    
    func deleteActivity(activityToDelete: Activity) async throws {
        activitiesCache.removeAll { $0.id == activityToDelete.id }
    }
    
    func addActivity(newActivity: NewActivity) async throws {
        let activity = Activity(
            id: UUID().uuidString,
            accountId: Config.accountId,
            type: newActivity.type,
            startTime: newActivity.startTime,
            endTime: newActivity.endTime,
            amount: newActivity.amount,
            meta: newActivity.meta
        )
        activitiesCache.insert(activity, at: 0)
    }
    
    func clearCache() {
        activitiesCache.removeAll()
    }
    
    func refreshCache() async throws {
        _ = try await fetchActivities(page: 1, pageSize: 10)
    }
}
