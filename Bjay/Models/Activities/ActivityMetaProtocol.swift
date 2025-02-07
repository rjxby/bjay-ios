//
//  ActivityMetaProtocol.swift
//  Bjay
//
//  Created by Vlad Kochin on 1/18/25.
//

protocol ActivityMetaProtocol: Codable {
    static var activityType: ActivityType { get }
}
