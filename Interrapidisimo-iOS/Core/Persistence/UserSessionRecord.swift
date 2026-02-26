//
//  UserSessionRecord.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import GRDB

struct UserSessionRecord: FetchableRecord, PersistableRecord {
    static let databaseTableName = "user_session"

    var username: String
    var documentId: String?
    var name: String?

    init(
        username: String,
        documentId: String?,
        name: String?
    ) {
        self.username = username
        self.documentId = documentId
        self.name = name
    }

    init(row: Row) throws {
        username = row["usuario"]
        documentId = row["identificacion"]
        name = row["nombre"]
    }

    func encode(to container: inout PersistenceContainer) throws {
        container["usuario"] = username
        container["identificacion"] = documentId
        container["nombre"] = name
    }
}
