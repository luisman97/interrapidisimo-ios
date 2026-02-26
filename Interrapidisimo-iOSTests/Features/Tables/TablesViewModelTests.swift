//
//  TablesViewModelTests.swift
//  Interrapidisimo-iOSTests
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import Testing
@testable import Interrapidisimo_iOS

@Suite("TablesViewModel")
@MainActor
struct TablesViewModelTests {

    private func makeSchema(name: String = "TBL_TEST") -> TableSchema {
        TableSchema(
            tableName: name,
            pk: "ID",
            creationQuery: "CREATE TABLE \(name) (ID INT PRIMARY KEY)",
            batchSize: 100,
            filter: "",
            error: nil,
            fieldCount: 1,
            appMethod: nil,
            lastSyncDate: "2026-01-01"
        )
    }

    // MARK: Happy path

    @Test func fetchTables_setsLoadedState_withCorrectCount() async {
        let schemas = [makeSchema(name: "TBL_A"), makeSchema(name: "TBL_B")]
        let useCase = MockFetchTablesUseCase(schemas: schemas)
        let sut = TablesViewModel(useCase: useCase, username: "testUser")

        await sut.fetchTables()

        if case .loaded(let result) = sut.state {
            #expect(result.count == 2)
        } else {
            Issue.record("Expected .loaded state, but got \(sut.state)")
        }
    }

    @Test func fetchTables_setsLoadedState_withCorrectSchemaNames() async {
        let schemas = [makeSchema(name: "TBL_A"), makeSchema(name: "TBL_B")]
        let useCase = MockFetchTablesUseCase(schemas: schemas)
        let sut = TablesViewModel(useCase: useCase, username: "testUser")

        await sut.fetchTables()

        if case .loaded(let result) = sut.state {
            #expect(result[0].tableName == "TBL_A")
            #expect(result[1].tableName == "TBL_B")
        } else {
            Issue.record("Expected .loaded state, but got \(sut.state)")
        }
    }

    @Test func fetchTables_setsLoadedWithEmptyArray_whenNoSchemas() async {
        let useCase = MockFetchTablesUseCase(schemas: [])
        let sut = TablesViewModel(useCase: useCase, username: "testUser")

        await sut.fetchTables()

        if case .loaded(let result) = sut.state {
            #expect(result.isEmpty)
        } else {
            Issue.record("Expected .loaded state, but got \(sut.state)")
        }
    }

    // MARK: Network error

    @Test func fetchTables_setsFailedState_onNetworkError() async {
        let useCase = MockFetchTablesUseCase(error: NetworkError.status(500))
        let sut = TablesViewModel(useCase: useCase, username: "testUser")

        await sut.fetchTables()

        if case .failed = sut.state { } else {
            Issue.record("Expected .failed state, but got \(sut.state)")
        }
    }

    // MARK: Unexpected error

    @Test func fetchTables_setsGenericFailedMessage_onUnexpectedError() async {
        struct SomeError: Error {}
        let useCase = MockFetchTablesUseCase(error: SomeError())
        let sut = TablesViewModel(useCase: useCase, username: "testUser")

        await sut.fetchTables()

        if case .failed(let message) = sut.state {
            #expect(message == "Error inesperado al cargar tablas.")
        } else {
            Issue.record("Expected .failed state, but got \(sut.state)")
        }
    }

    // MARK: Initial state

    @Test func initialState_isLoading() {
        let sut = TablesViewModel(useCase: MockFetchTablesUseCase(), username: "u")
        if case .loading = sut.state { } else {
            Issue.record("Expected initial .loading state, but got \(sut.state)")
        }
    }
}
