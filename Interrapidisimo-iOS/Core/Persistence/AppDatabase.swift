//
//  AppDatabase.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import Foundation
import GRDB

enum AppDatabaseError: Error {
    case documentsDirectoryUnavailable
}

/// A database manager that handles SQLite database operations for the Interrapidisimo app.
///
/// `AppDatabase` encapsulates the GRDB `DatabaseQueue` and manages the database lifecycle,
/// including initialization and schema migrations. The database file is stored in the app's
/// documents directory as "interrapidisimo.sqlite".
///
/// ## Topics
///
/// ### Database Queue
///
/// - ``dbQueue``: The underlying GRDB database queue for performing database operations.
///
/// ### Initialization
///
/// - ``init()``: Creates a new database instance, establishing the database file and running migrations.
///
/// ## Example
///
/// ```swift
/// do {
///     let database = try AppDatabase()
///     // Use database.dbQueue for database operations
/// } catch {
///     print("Failed to initialize database: \(error)")
/// }
/// ```
///
/// - Note: The database automatically creates and migrates tables on initialization.
/// - Throws: An error if the database file cannot be created or migrations fail.
struct AppDatabase {
    let dbQueue: DatabaseQueue

    init() throws {
        guard let documentsURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw AppDatabaseError.documentsDirectoryUnavailable
        }
        let url = documentsURL.appendingPathComponent("interrapidisimo.sqlite")
        dbQueue = try DatabaseQueue(path: url.path)
        try migrate()
    }
}

// MARK: - Private Methods

private extension AppDatabase {
    func migrate() throws {
        var migrator = DatabaseMigrator()
        migrator.registerMigration("v1_user_session") { db in
            try db.create(table: "user_session", ifNotExists: true) { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("usuario", .text).notNull()
                t.column("identificacion", .text)
                t.column("nombre", .text)
            }
        }
        migrator.registerMigration("v2_tabla_schema") { db in
            try db.create(table: "tabla_schema", ifNotExists: true) { t in
                t.column("nombre_tabla", .text).primaryKey()
                t.column("pk", .text).notNull()
                t.column("query_creacion", .text).notNull()
                t.column("batch_size", .integer).notNull()
                t.column("filtro", .text).notNull()
                t.column("error", .text)
                t.column("numero_campos", .integer).notNull()
                t.column("metodo_app", .text)
                t.column("fecha_actualizacion_sincro", .text).notNull()
            }
        }
        try migrator.migrate(dbQueue)
    }
}
