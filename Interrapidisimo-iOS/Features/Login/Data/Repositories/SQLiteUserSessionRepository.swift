//
//  SQLiteUserSessionRepository.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import GRDB

struct SQLiteUserSessionRepository: UserSessionRepositoryProtocol {
    private let dbQueue: DatabaseQueue

    init(dbQueue: DatabaseQueue) {
        self.dbQueue = dbQueue
    }

    func save(_ session: UserSession) async throws {
        let record = UserSessionRecord(
            username: session.username,
            documentId: session.documentId,
            name: session.name
        )
        try await dbQueue.write { db in
            try UserSessionRecord.deleteAll(db)
            try record.insert(db)
        }
    }

    func currentSession() async throws -> UserSession? {
        let record: UserSessionRecord? = try await dbQueue.read { db in
            try UserSessionRecord.fetchOne(db)
        }
        guard let record else { return nil }
        return UserSession(
            username: record.username,
            documentId: record.documentId,
            name: record.name
        )
    }

    func clearSession() async throws {
        _ = try await dbQueue.write { db in
            try UserSessionRecord.deleteAll(db)
        }
    }
}
