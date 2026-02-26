//
//  TableSchemaRecord.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import GRDB

struct TableSchemaRecord: FetchableRecord, PersistableRecord {
    static let databaseTableName = "tabla_schema"

    var tableName: String
    var pk: String
    var creationQuery: String
    var batchSize: Int
    var filter: String
    var error: String?
    var fieldCount: Int
    var appMethod: String?
    var lastSyncDate: String

    init(from schema: TableSchema) {
        tableName = schema.tableName
        pk = schema.pk
        creationQuery = schema.creationQuery
        batchSize = schema.batchSize
        filter = schema.filter
        error = schema.error
        fieldCount = schema.fieldCount
        appMethod = schema.appMethod
        lastSyncDate = schema.lastSyncDate
    }

    init(row: Row) throws {
        tableName = row["nombre_tabla"]
        pk = row["pk"]
        creationQuery = row["query_creacion"]
        batchSize = row["batch_size"]
        filter = row["filtro"]
        error = row["error"]
        fieldCount = row["numero_campos"]
        appMethod = row["metodo_app"]
        lastSyncDate = row["fecha_actualizacion_sincro"]
    }

    func encode(to container: inout PersistenceContainer) throws {
        container["nombre_tabla"] = tableName
        container["pk"] = pk
        container["query_creacion"] = creationQuery
        container["batch_size"] = batchSize
        container["filtro"] = filter
        container["error"] = error
        container["numero_campos"] = fieldCount
        container["metodo_app"] = appMethod
        container["fecha_actualizacion_sincro"] = lastSyncDate
    }
}
