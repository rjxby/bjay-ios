//
//  ActivityServiceProtocol.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/29/24.
//

protocol ActivityServiceProtocol {
    func fetchActivities(page: Int, pageSize: Int) async throws -> PaginationResponse<Activity>
    func addActivity(request: CreateActivityRequest) async throws -> Activity
    func deleteActivity(id: String) async throws -> Bool
}
