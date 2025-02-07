//
//  Activity.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/25/24.
//

import Foundation

struct Activity: Identifiable, Codable {
    let id: String
    let accountId: String
    let type: ActivityType
    let startTime: Date
    let endTime: Date?
    let amount: Double?
    let meta: ActivityMeta?
}
