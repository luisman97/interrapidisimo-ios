//
//  TableSchemaDTO+Mapping.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

extension TableSchemaDTO {
    var toDomain: TableSchema {
        TableSchema(
            tableName: tableName,
            pk: pk,
            creationQuery: creationQuery,
            batchSize: batchSize,
            filter: filter,
            error: error,
            fieldCount: fieldCount,
            appMethod: appMethod,
            lastSyncDate: lastSyncDate
        )
    }
}
