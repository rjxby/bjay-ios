//
//  DiaperType.swift
//  Bjay
//
//  Created by Vlad Kochin on 1/14/25.
//

enum DiaperType: Int, Codable, CaseIterable {
    case wet = 1
    case dirty = 2
    case mixed = 3
    
    var displayName: String {
        switch self {
        case .wet: return "Wet"
        case .dirty: return "Dirty"
        case .mixed: return "Mixed"
        }
    }
}
