//
//  LoginUseCaseTests.swift
//  Interrapidisimo-iOSTests
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import Testing
import Foundation
@testable import Interrapidisimo_iOS

@Suite("LoginUseCase")
struct LoginUseCaseTests {

    private func makeCredentials(
        username: String = "testUser",
        password: String = "pass123"
    ) -> LoginCredentials {
        LoginCredentials(
            username: username,
            documentId: "12345",
            serviceOfficeId: "1",
            serviceOfficeName: "Sede Test",
            password: password
        )
    }

    private func makeSession(username: String = "testUser") -> UserSession {
        UserSession(username: username, documentId: "12345", name: "Juan Test")
    }

    @MainActor
    @Test func execute_returnsSession_onSuccessfulLogin() async throws {
        let expected = makeSession()
        let loginRepo = MockLoginRepository(session: expected)
        let sessionRepo = MockUserSessionRepository()
        let sut = LoginUseCase(loginRepository: loginRepo, sessionRepository: sessionRepo)

        let result = try await sut.execute(credentials: makeCredentials())

        #expect(result == expected)
    }

    @MainActor
    @Test func execute_savesSession_afterSuccessfulLogin() async throws {
        let expected = makeSession()
        let loginRepo = MockLoginRepository(session: expected)
        let sessionRepo = MockUserSessionRepository()
        let sut = LoginUseCase(loginRepository: loginRepo, sessionRepository: sessionRepo)

        _ = try await sut.execute(credentials: makeCredentials())

        #expect(sessionRepo.saveCallCount == 1)
        #expect(sessionRepo.savedSession == expected)
    }

    @Test func execute_propagatesError_whenLoginFails() async throws {
        let loginRepo = MockLoginRepository(error: NetworkError.status(401))
        let sessionRepo = MockUserSessionRepository()
        let sut = await LoginUseCase(loginRepository: loginRepo, sessionRepository: sessionRepo)

        await #expect(throws: NetworkError.self) {
            try await sut.execute(credentials: makeCredentials())
        }
    }

    @Test func execute_doesNotSaveSession_whenLoginFails() async throws {
        let loginRepo = MockLoginRepository(error: NetworkError.status(401))
        let sessionRepo = MockUserSessionRepository()
        let sut = await LoginUseCase(loginRepository: loginRepo, sessionRepository: sessionRepo)

        _ = try? await sut.execute(credentials: makeCredentials())

        #expect(sessionRepo.saveCallCount == 0)
    }
}
