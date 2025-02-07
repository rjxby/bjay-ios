//
//  DefaultDateFormatterProvider.swift
//  Bjay
//
//  Created by Vlad Kochin on 1/3/25.
//

import Foundation

class DefaultDateFormatterProvider: DateFormatterProviderProtocol {
    let encoder: JSONEncoder
    let decoder: JSONDecoder
    
    init() {
        encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .custom { date, encoder in
            var container = encoder.singleValueContainer()
            
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            let dateString = formatter.string(from: date)
            try container.encode(dateString)
        }
        
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            if let date = formatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid date format: \(dateString)"
            )
        }
    }
}
