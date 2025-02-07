//
//  IdentifiableError.swift
//  Bjay
//
//  Created by Vlad Kochin on 1/1/25.
//

import Foundation

struct IdentifiableError: Identifiable {
    let id = UUID()
    let message: String
}
