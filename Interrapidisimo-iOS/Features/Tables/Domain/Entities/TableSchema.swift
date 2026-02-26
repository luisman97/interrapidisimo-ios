//
//  TableSchema.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

struct TableSchema: Sendable {
    let tableName: String
    let pk: String
    let creationQuery: String
    let batchSize: Int
    let filter: String
    let error: String?
    let fieldCount: Int
    let appMethod: String?
    let lastSyncDate: String
}
