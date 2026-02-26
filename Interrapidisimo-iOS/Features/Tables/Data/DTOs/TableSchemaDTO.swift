//
//  TableSchemaDTO.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

struct TableSchemaDTO: Decodable {
    let tableName: String
    let pk: String
    let creationQuery: String
    let batchSize: Int
    let filter: String
    let error: String?
    let fieldCount: Int
    let appMethod: String?
    let lastSyncDate: String

    enum CodingKeys: String, CodingKey {
        case tableName = "NombreTabla"
        case pk = "Pk"
        case creationQuery = "QueryCreacion"
        case batchSize = "BatchSize"
        case filter = "Filtro"
        case error = "Error"
        case fieldCount = "NumeroCampos"
        case appMethod = "MetodoApp"
        case lastSyncDate = "FechaActualizacionSincro"
    }
}
