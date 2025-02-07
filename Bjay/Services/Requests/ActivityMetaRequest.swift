//
//  ActivityMetaRequest.swift
//  Bjay
//
//  Created by Vlad Kochin on 1/14/25.
//

enum ActivityMetaRequest: Codable {
    case diaper(DiaperMetaRequest)
    // Add other meta types as needed.

    enum CodingKeys: String, CodingKey {
        case type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(DiaperType.self, forKey: .type)
        switch type {
        case .wet, .dirty, .mixed:
            self = .diaper(try DiaperMetaRequest(from: decoder))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .diaper(let meta):
            try container.encode(meta.type, forKey: .type)
            try meta.encode(to: encoder)
        }
    }
}

