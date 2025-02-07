//
//  PaginationResponse.swift
//  Bjay
//
//  Created by Vlad Kochin on 12/26/24.
//

import Foundation

struct PaginationResponse<T: Codable>: Codable {
    let page: Int
    let limit: Int
    let size: Int
    let results: [T]
}
