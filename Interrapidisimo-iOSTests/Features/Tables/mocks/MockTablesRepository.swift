//
//  MockTablesRepository.swift
//  Interrapidisimo-iOSTests
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import Foundation
@testable import Interrapidisimo_iOS

final class MockTablesRepository: TablesRepositoryProtocol {
    var schemasToReturn: [TableSchema]
    var errorToThrow: NetworkError?

    init(schemas: [TableSchema] = [], error: NetworkError? = nil) {
        self.schemasToReturn = schemas
        self.errorToThrow = error
    }

    func fetchSchemas(user: String) async throws(NetworkError) -> [TableSchema] {
        if let error = errorToThrow { throw error }
        return schemasToReturn
    }
}
