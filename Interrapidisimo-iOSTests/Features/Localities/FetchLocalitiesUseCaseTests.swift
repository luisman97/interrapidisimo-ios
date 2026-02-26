//
//  FetchLocalitiesUseCaseTests.swift
//  Interrapidisimo-iOSTests
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import Testing
import Foundation
@testable import Interrapidisimo_iOS

@Suite("FetchLocalitiesUseCase")
struct FetchLocalitiesUseCaseTests {

    private func makeLocality(id: String = "1") -> Locality {
        Locality(
            localityId: id,
            cityAbbreviation: "BOG",
            fullName: "Bogotá D.C."
        )
    }

    @Test func execute_returnsLocalitiesFromRepository() async throws {
        let localities = [makeLocality(id: "1"), makeLocality(id: "2")]
        let repo = MockLocalitiesRepository(localities: localities)
        let sut = await FetchLocalitiesUseCase(repository: repo)

        let result = try await sut.execute()

        #expect(result.count == 2)
    }

    @Test func execute_returnsEmptyArray_whenRepositoryReturnsEmpty() async throws {
        let repo = MockLocalitiesRepository(localities: [])
        let sut = await FetchLocalitiesUseCase(repository: repo)

        let result = try await sut.execute()

        #expect(result.isEmpty)
    }

    @Test func execute_propagatesError_whenRepositoryThrows() async throws {
        let repo = MockLocalitiesRepository(error: NetworkError.dataNotValid)
        let sut = await FetchLocalitiesUseCase(repository: repo)

        await #expect(throws: NetworkError.self) {
            try await sut.execute()
        }
    }

    @MainActor
    @Test func execute_preservesOrderFromRepository() async throws {
        let localities = ["5", "1", "3"].map { makeLocality(id: $0) }
        let repo = MockLocalitiesRepository(localities: localities)
        let sut = FetchLocalitiesUseCase(repository: repo)

        let result = try await sut.execute()

        #expect(result[0].localityId == "5")
        #expect(result[1].localityId == "1")
        #expect(result[2].localityId == "3")
    }
}
