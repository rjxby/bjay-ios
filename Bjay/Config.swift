//
//  Config.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/27/24.
//

import Foundation

struct Config {
    static var accountId: String {
        return Bundle.main.object(forInfoDictionaryKey: "ACCOUNT_ID") as? String ?? ""
    }
    static var baseURL: String {
        return Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? ""
    }
    static let feedingInteravalInMinutes: Double = 180
    static let maxFeedingAmount: Double = 32
}
