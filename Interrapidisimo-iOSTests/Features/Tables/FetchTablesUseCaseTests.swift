//
//  FetchTablesUseCaseTests.swift
//  Interrapidisimo-iOSTests
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import Testing
import Foundation
@testable import Interrapidisimo_iOS

@Suite("FetchTablesUseCase")
struct FetchTablesUseCaseTests {

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

    @MainActor
    @Test func execute_returnsSchemasFromRemote() async throws {
        let schemas = [makeSchema(name: "TBL_A"), makeSchema(name: "TBL_B")]
        let remote = MockTablesRepository(schemas: schemas)
        let local = MockTablesLocalRepository()
        let sut = FetchTablesUseCase(remoteRepository: remote, localRepository: local)

        let result = try await sut.execute(username: "testUser")

        #expect(result.count == 2)
        #expect(result[0].tableName == "TBL_A")
        #expect(result[1].tableName == "TBL_B")
    }

    @Test func execute_savesResultsLocally() async throws {
        let schemas = [makeSchema(name: "TBL_A"), makeSchema(name: "TBL_B")]
        let remote = MockTablesRepository(schemas: schemas)
        let local = MockTablesLocalRepository()
        let sut = await FetchTablesUseCase(remoteRepository: remote, localRepository: local)

        _ = try await sut.execute(username: "testUser")

        #expect(local.saveCallCount == 1)
        #expect(local.savedSchemas.count == 2)
    }

    @Test func execute_returnsEmptyArray_whenRemoteReturnsEmpty() async throws {
        let remote = MockTablesRepository(schemas: [])
        let local = MockTablesLocalRepository()
        let sut = await FetchTablesUseCase(remoteRepository: remote, localRepository: local)

        let result = try await sut.execute(username: "testUser")

        #expect(result.isEmpty)
    }

    @Test func execute_propagatesError_whenRemoteFails() async throws {
        let remote = MockTablesRepository(error: NetworkError.status(500))
        let local = MockTablesLocalRepository()
        let sut = await FetchTablesUseCase(remoteRepository: remote, localRepository: local)

        await #expect(throws: NetworkError.self) {
            try await sut.execute(username: "testUser")
        }
    }

    @Test func execute_doesNotSaveLocally_whenRemoteFails() async throws {
        let remote = MockTablesRepository(error: NetworkError.status(500))
        let local = MockTablesLocalRepository()
        let sut = await FetchTablesUseCase(remoteRepository: remote, localRepository: local)

        _ = try? await sut.execute(username: "testUser")

        #expect(local.saveCallCount == 0)
    }
}
