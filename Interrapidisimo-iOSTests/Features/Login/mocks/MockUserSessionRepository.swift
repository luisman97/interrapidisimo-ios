//
//  MockUserSessionRepository.swift
//  Interrapidisimo-iOSTests
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import Foundation
@testable import Interrapidisimo_iOS

final class MockUserSessionRepository: UserSessionRepositoryProtocol {
    var savedSession: UserSession?
    var errorToThrow: Error?
    private(set) var saveCallCount = 0
    private(set) var clearCallCount = 0

    func save(_ session: UserSession) async throws {
        if let error = errorToThrow { throw error }
        savedSession = session
        saveCallCount += 1
    }

    func currentSession() async throws -> UserSession? {
        if let error = errorToThrow { throw error }
        return savedSession
    }

    func clearSession() async throws {
        if let error = errorToThrow { throw error }
        savedSession = nil
        clearCallCount += 1
    }
}
