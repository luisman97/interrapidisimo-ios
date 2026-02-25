//
//  CheckVersionUseCase.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import Foundation

protocol CheckVersionUseCaseProtocol {
    func execute() async throws -> VersionStatus
}

final class CheckVersionUseCase: CheckVersionUseCaseProtocol {
    private let repository: VersionCheckRepositoryProtocol

    init(repository: VersionCheckRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> VersionStatus {
        let remoteVersionString = try await repository.fetchRemoteVersion()
        let localVersionString = Bundle.main.appVersion

        guard let remote = SemanticVersion(remoteVersionString),
              let local = SemanticVersion(localVersionString) else {
            return .upToDate
        }

        if local < remote {
            return .updateAvailable(remoteVersion: remoteVersionString)
        } else if local > remote {
            return .versionAhead(remoteVersion: remoteVersionString)
        } else {
            return .upToDate
        }
    }
}
