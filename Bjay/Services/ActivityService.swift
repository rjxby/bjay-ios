import Foundation
import os

class ActivityService: ActivityServiceProtocol {
    private let logger: Logger
    private let networkClient: NetworkClient
    private let dateFormatterProvider: DateFormatterProviderProtocol

    init(logger: Logger = Logger(subsystem: "com.bjay.app", category: "Network"),
         dateFormatterProvider: DateFormatterProviderProtocol = DefaultDateFormatterProvider()) {
        self.logger = logger
        self.networkClient = NetworkClient(logger: logger, dateFormatterProvider: dateFormatterProvider)
        self.dateFormatterProvider = dateFormatterProvider
    }

    func fetchActivities(page: Int, pageSize: Int) async throws -> PaginationResponse<Activity> {
        guard var components = URLComponents(string: "\(Config.baseURL)/activities") else {
            logger.error("Invalid URL for fetchActivities")
            throw NetworkingError.invalidURL
        }

        components.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "limit", value: String(pageSize))
        ]

        guard let url = components.url else {
            logger.error("Failed to construct URL for fetchActivities")
            throw NetworkingError.invalidURL
        }

        let request = URLRequest(url: url)
        return try await networkClient.request(request, decodingType: PaginationResponse<Activity>.self)
    }

    func addActivity(request: CreateActivityRequest) async throws -> Activity {
        guard let url = URL(string: "\(Config.baseURL)/activities") else {
            logger.error("Invalid URL for addActivity")
            throw NetworkingError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try dateFormatterProvider.encoder.encode(request)

        return try await networkClient.request(urlRequest, decodingType: Activity.self)
    }

    func deleteActivity(id: String) async throws -> Bool {
        guard let components = URLComponents(string: "\(Config.baseURL)/activities/\(id)") else {
            logger.error("Invalid URL for deleteActivity")
            throw NetworkingError.invalidURL
        }

        guard let url = components.url else {
            logger.error("Failed to construct URL for deleteActivity")
            throw NetworkingError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        return try await networkClient.request(urlRequest, decodingType: Bool.self)
    }
}
