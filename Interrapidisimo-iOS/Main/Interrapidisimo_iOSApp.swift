//
//  Interrapidisimo_iOSApp.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import SwiftUI
import OSLog

private let appLogger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "com.interrapidisimo",
    category: "app"
)

@main
struct Interrapidisimo_iOSApp: App {
    @State private var session: UserSession?
    @State private var didRestoreSession = false

    var body: some Scene {
        WindowGroup {
            VersionCheckFactory.getVersionCheckView {
                if !didRestoreSession {
                    ProgressView()
                        .task { await restoreSessionIfNeeded() }
                } else if let session {
                    HomeFactory.getHomeView(
                        session: session,
                        onLogout: { Task { await logout() } }
                    )
                } else {
                    LoginFactory.getLoginView { userSession in
                        session = userSession
                    }
                }
            }
        }
    }
}

// MARK: - Private Methods

@MainActor
private extension Interrapidisimo_iOSApp {
    func restoreSessionIfNeeded() async {
        guard !didRestoreSession else { return }
        defer { didRestoreSession = true }
        do {
            let appDatabase = try AppDatabase()
            let sessionRepository = SQLiteUserSessionRepository(dbQueue: appDatabase.dbQueue)
            session = try await sessionRepository.currentSession()
        } catch {
            session = nil
        }
    }

    func logout() async {
        do {
            let appDatabase = try AppDatabase()
            let sessionRepository = SQLiteUserSessionRepository(dbQueue: appDatabase.dbQueue)
            try await sessionRepository.clearSession()
        } catch {
            appLogger.error("Failed to clear persisted session: \(error.localizedDescription, privacy: .public)")
        }
        session = nil
    }
}
