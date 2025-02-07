//
//  ActivityRequest.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/26/24.
//

import Foundation

struct CreateActivityRequest: Codable {
    let accountId: String
    let type: ActivityType
    let startTime: Date
    let endTime: Date?
    let amount: Double?
    let meta: ActivityMeta?
}
