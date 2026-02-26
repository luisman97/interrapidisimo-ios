//
//  MockTablesLocalRepository.swift
//  Interrapidisimo-iOSTests
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import Foundation
@testable import Interrapidisimo_iOS

final class MockTablesLocalRepository: TablesLocalRepositoryProtocol {
    var savedSchemas: [TableSchema] = []
    var errorToThrow: Error?
    private(set) var saveCallCount = 0

    func saveSchemas(_ schemas: [TableSchema]) async throws {
        if let error = errorToThrow { throw error }
        savedSchemas = schemas
        saveCallCount += 1
    }
}
