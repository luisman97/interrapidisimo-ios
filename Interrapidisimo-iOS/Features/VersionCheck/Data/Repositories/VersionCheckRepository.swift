//
//  VersionCheckRepository.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import Foundation

final class VersionCheckRepository: VersionCheckRepositoryProtocol {
    private let httpClient: HTTPClientProtocol

    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }

    func fetchRemoteVersion() async throws -> String {
        try await httpClient.get(
            .versionCheck,
            as: String.self
        )
    }
}
