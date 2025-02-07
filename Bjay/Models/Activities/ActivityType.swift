//
//  ActivityType.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/25/24.
//

import Foundation

enum ActivityType: Int, Codable {
    case feed = 1
    case diaper = 2
    case sleep = 3
    
    var stringValue: String {
        switch self {
        case .feed: return "Feed"
        case .diaper: return "Diaper"
        case .sleep: return "Sleep"
        }
    }

    init?(stringValue: String) {
        switch stringValue {
        case "Feed": self = .feed
        case "Diaper": self = .diaper
        case "Sleep": self = .sleep
        default: return nil
        }
    }
}
