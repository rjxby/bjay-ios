//
//  ActivityRepositoryProtocol.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/29/24.
//

@MainActor
protocol ActivityRepositoryProtocol {
    // Cache access
    var activitiesCache: [Activity] { get }
    
    // Network operations
    func fetchActivities(page: Int, pageSize: Int) async throws -> PaginationResponse<Activity>
    func deleteActivity(activityToDelete: Activity) async throws
    func addActivity(newActivity: NewActivity) async throws
    
    // Cache management
    func clearCache()
    func refreshCache() async throws
}
