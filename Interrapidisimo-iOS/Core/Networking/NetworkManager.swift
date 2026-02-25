//
//  NetworkManager.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import Foundation
import OSLog

private let networkLogger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "com.interrapidisimo",
    category: "network"
)

// MARK: - Protocol

protocol HTTPClientProtocol {
    func get<T: Decodable & Sendable>(
        _ url: URL,
        as type: T.Type
    ) async throws -> T
}

// MARK: - Concrete implementation

struct HTTPClient: HTTPClientProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func get<T: Decodable & Sendable>(
        _ url: URL,
        as type: T.Type
    ) async throws -> T {
        let request = URLRequest.get(url)
        networkLogger.debug("Request URL: \(request.url?.absoluteString ?? "Unknown URL", privacy: .public)")
        let (data, httpResponse) = try await session.getData(for: request)
        networkLogger.debug("Response StatusCode: \(httpResponse.statusCode)")
        guard httpResponse.statusCode == 200 else {
            networkLogger.error("Response error: \(httpResponse.statusCode)")
            throw NetworkError.status(httpResponse.statusCode)
        }
        do {
            return try JSONDecoder().decode(
                type,
                from: data
            )
        } catch {
            throw NetworkError.json(error)
        }
    }
}
