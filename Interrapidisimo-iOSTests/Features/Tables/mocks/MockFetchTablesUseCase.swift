//
//  MockFetchTablesUseCase.swift
//  Interrapidisimo-iOSTests
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import Foundation
@testable import Interrapidisimo_iOS

final class MockFetchTablesUseCase: FetchTablesUseCaseProtocol {
    var schemasToReturn: [TableSchema]
    var errorToThrow: Error?

    init(schemas: [TableSchema] = [], error: Error? = nil) {
        self.schemasToReturn = schemas
        self.errorToThrow = error
    }

    func execute(username: String) async throws -> [TableSchema] {
        if let error = errorToThrow { throw error }
        return schemasToReturn
    }
}
