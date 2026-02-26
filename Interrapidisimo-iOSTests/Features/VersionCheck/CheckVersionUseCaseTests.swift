//
//  CheckVersionUseCaseTests.swift
//  Interrapidisimo-iOSTests
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import Testing
import Foundation
@testable import Interrapidisimo_iOS

@Suite("CheckVersionUseCase")
struct CheckVersionUseCaseTests {

    @MainActor
    @Test func execute_returnsUpdateAvailable_whenRemoteVersionIsMuchNewer() async throws {
        let repo = MockVersionCheckRepository(version: "999.0.0")
        let sut = CheckVersionUseCase(repository: repo)

        let result = try await sut.execute()

        #expect(result == .updateAvailable(remoteVersion: "999.0.0"))
    }

    @MainActor
    @Test func execute_returnsUpToDate_whenRemoteVersionEqualsLocal() async throws {
        // Read the actual local version so the test stays valid across version bumps.
        let localVersion = Bundle.main.appVersion
        let repo = MockVersionCheckRepository(version: localVersion)
        let sut = CheckVersionUseCase(repository: repo)

        let result = try await sut.execute()

        #expect(result == .upToDate)
    }

    @MainActor
    @Test func execute_returnsUpToDate_whenVersionStringIsInvalid() async throws {
        // Neither remote nor local can be parsed → falls back to .upToDate
        let repo = MockVersionCheckRepository(version: "not-a-version")
        let sut = CheckVersionUseCase(repository: repo)

        let result = try await sut.execute()

        #expect(result == .upToDate)
    }

    @MainActor
    @Test func execute_returnsVersionAhead_whenLocalIsNewerThanRemote() async throws {
        // Only meaningful if local version > 0.0.0 (true in every real build)
        let localVersion = Bundle.main.appVersion
        guard let local = SemanticVersion(localVersion),
              local > SemanticVersion("0.0.0")! else {
            // Version fallback is "0" → cannot go below it; skip gracefully.
            return
        }

        let repo = MockVersionCheckRepository(version: "0.0.0")
        let sut = CheckVersionUseCase(repository: repo)

        let result = try await sut.execute()

        #expect(result == .versionAhead(remoteVersion: "0.0.0"))
    }

    @Test func execute_propagatesError_whenRepositoryThrows() async throws {
        let repo = MockVersionCheckRepository(
            version: "1.0.0",
            error: NetworkError.status(500)
        )
        let sut = await CheckVersionUseCase(repository: repo)

        await #expect(throws: NetworkError.self) {
            try await sut.execute()
        }
    }
}
