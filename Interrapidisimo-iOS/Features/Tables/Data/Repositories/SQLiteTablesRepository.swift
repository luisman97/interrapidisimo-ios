//
//  SQLiteTablesRepository.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import GRDB

struct SQLiteTablesRepository: TablesLocalRepositoryProtocol {
    private let dbQueue: DatabaseQueue

    init(dbQueue: DatabaseQueue) {
        self.dbQueue = dbQueue
    }

    func saveSchemas(_ schemas: [TableSchema]) async throws {
        let records = schemas.map { TableSchemaRecord(from: $0) }
        try await dbQueue.write { db in
            try TableSchemaRecord.deleteAll(db)
            for record in records {
                try record.insert(db)
            }
        }
    }
}
