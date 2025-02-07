//
//  NewActivity.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/25/24.
//

import Foundation

struct NewActivity: Codable {
    let type: ActivityType
    let startTime: Date
    let endTime: Date?
    let amount: Double?
    let meta: ActivityMeta?
    
    func toCreateRequest(accountId: String) -> CreateActivityRequest {
        CreateActivityRequest(
            accountId: accountId,
            type: type,
            startTime: startTime,
            endTime: endTime,
            amount: amount,
            meta: meta
        )
    }
}
