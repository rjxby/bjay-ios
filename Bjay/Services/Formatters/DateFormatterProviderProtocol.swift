//
//  DateFormatterProviderProtocol.swift
//  Bjay
//
//  Created by Vlad Kochin on 1/3/25.
//

import Foundation

protocol DateFormatterProviderProtocol {
    var encoder: JSONEncoder { get }
    var decoder: JSONDecoder { get }
}
