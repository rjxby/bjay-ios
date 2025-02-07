//
//  ActivityMeta.swift
//  Bjay
//
//  Created by Vlad Kochin on 1/14/25.
//

enum ActivityMeta: Codable {
    case diaper(DiaperMeta)
    
    private enum CodingKeys: String, CodingKey {
        case type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(DiaperType.self, forKey: .type)
        self = .diaper(DiaperMeta(type: type))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .diaper(let meta):
            try container.encode(meta.type, forKey: .type)
        }
    }
}
