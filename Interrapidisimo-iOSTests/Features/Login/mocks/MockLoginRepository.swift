//
//  MockLoginRepository.swift
//  Interrapidisimo-iOSTests
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import Foundation
@testable import Interrapidisimo_iOS

final class MockLoginRepository: LoginRepositoryProtocol {
    var sessionToReturn: UserSession?
    var errorToThrow: NetworkError?

    init(session: UserSession? = nil, error: NetworkError? = nil) {
        self.sessionToReturn = session
        self.errorToThrow = error
    }

    func login(credentials: LoginCredentials) async throws(NetworkError) -> UserSession {
        if let error = errorToThrow { throw error }
        return sessionToReturn ?? UserSession(
            username: credentials.username,
            documentId: credentials.documentId,
            name: nil
        )
    }
}
