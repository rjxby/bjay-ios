//
//  NetworkClient.swift
//  Bjay
//
//  Created by Vlad Kochin on 1/14/25.
//

import Foundation
import os

class NetworkClient {
    private let logger: Logger
    private let dateFormatterProvider: DateFormatterProviderProtocol
    
    init(logger: Logger = Logger(subsystem: "com.bjay.app", category: "Network"),
    dateFormatterProvider: DateFormatterProviderProtocol = DefaultDateFormatterProvider()) {
        self.logger = logger
        self.dateFormatterProvider = dateFormatterProvider
    }

    func request<T: Decodable>(_ urlRequest: URLRequest, decodingType: T.Type) async throws -> T {
        logger.info("Sending \(urlRequest.httpMethod ?? "UNKNOWN") request to \(urlRequest.url?.absoluteString ?? "UNKNOWN")")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse {
            logger.info("Received response: Status Code \(httpResponse.statusCode)")
            logger.info("Response Headers: \(httpResponse.allHeaderFields.description)")
        }

        logger.debug("Response Body: \(String(data: data, encoding: .utf8) ?? "Unable to decode response")")
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            logger.error("Invalid response: \(response)")
            throw NetworkingError.invalidResponse
        }
        
        do {
            return try dateFormatterProvider.decoder.decode(T.self, from: data)
        } catch {
            logger.error("Failed to decode response: \(error.localizedDescription)")
            throw NetworkingError.invalidResponse
        }
    }
}
