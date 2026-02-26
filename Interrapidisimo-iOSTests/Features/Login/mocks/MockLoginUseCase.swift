//
//  MockLoginUseCase.swift
//  Interrapidisimo-iOSTests
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import Foundation
@testable import Interrapidisimo_iOS

final class MockLoginUseCase: LoginUseCaseProtocol {
    var sessionToReturn: UserSession?
    var errorToThrow: Error?

    init(session: UserSession? = nil, error: Error? = nil) {
        self.sessionToReturn = session
        self.errorToThrow = error
    }

    func execute(credentials: LoginCredentials) async throws -> UserSession {
        if let error = errorToThrow { throw error }
        return sessionToReturn ?? UserSession(
            username: credentials.username,
            documentId: credentials.documentId,
            name: nil
        )
    }
}
