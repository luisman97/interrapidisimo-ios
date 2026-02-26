//
//  LocalitiesViewModelTests.swift
//  Interrapidisimo-iOSTests
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import Testing
@testable import Interrapidisimo_iOS

@Suite("LocalitiesViewModel")
@MainActor
struct LocalitiesViewModelTests {

    private func makeLocality(id: String = "1") -> Locality {
        Locality(
            localityId: id,
            cityAbbreviation: "BOG",
            fullName: "Bogotá D.C."
        )
    }

    // MARK: Happy path

    @Test func fetchLocalities_setsLoadedState_withCorrectCount() async {
        let localities = [makeLocality(id: "1"), makeLocality(id: "2")]
        let useCase = MockFetchLocalitiesUseCase(localities: localities)
        let sut = LocalitiesViewModel(useCase: useCase)

        await sut.fetchLocalities()

        if case .loaded(let result) = sut.state {
            #expect(result.count == 2)
        } else {
            Issue.record("Expected .loaded state, but got \(sut.state)")
        }
    }

    @Test func fetchLocalities_setsLoadedWithEmptyArray_whenNoLocalities() async {
        let useCase = MockFetchLocalitiesUseCase(localities: [])
        let sut = LocalitiesViewModel(useCase: useCase)

        await sut.fetchLocalities()

        if case .loaded(let result) = sut.state {
            #expect(result.isEmpty)
        } else {
            Issue.record("Expected .loaded state, but got \(sut.state)")
        }
    }

    @Test func fetchLocalities_preservesOrderFromUseCase() async {
        let localities = ["5", "1", "3"].map { makeLocality(id: $0) }
        let useCase = MockFetchLocalitiesUseCase(localities: localities)
        let sut = LocalitiesViewModel(useCase: useCase)

        await sut.fetchLocalities()

        if case .loaded(let result) = sut.state {
            #expect(result[0].localityId == "5")
            #expect(result[1].localityId == "1")
            #expect(result[2].localityId == "3")
        } else {
            Issue.record("Expected .loaded state, but got \(sut.state)")
        }
    }

    // MARK: Network error

    @Test func fetchLocalities_setsFailedState_onNetworkError() async {
        let useCase = MockFetchLocalitiesUseCase(error: NetworkError.status(503))
        let sut = LocalitiesViewModel(useCase: useCase)

        await sut.fetchLocalities()

        if case .failed = sut.state { } else {
            Issue.record("Expected .failed state, but got \(sut.state)")
        }
    }

    // MARK: Unexpected error

    @Test func fetchLocalities_setsGenericFailedMessage_onUnexpectedError() async {
        let useCase = MockFetchLocalitiesUseCase(error: .dataNotValid)
        let sut = LocalitiesViewModel(useCase: useCase)

        await sut.fetchLocalities()

        if case .failed(let message) = sut.state {
            #expect(message == "Invalid data received from server")
        } else {
            Issue.record("Expected .failed state, but got \(sut.state)")
        }
    }

    // MARK: Initial state

    @Test func initialState_isLoading() {
        let sut = LocalitiesViewModel(useCase: MockFetchLocalitiesUseCase())
        if case .loading = sut.state { } else {
            Issue.record("Expected initial .loading state, but got \(sut.state)")
        }
    }
}
