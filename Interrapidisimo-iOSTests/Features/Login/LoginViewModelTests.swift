//
//  LoginViewModelTests.swift
//  Interrapidisimo-iOSTests
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import Testing
@testable import Interrapidisimo_iOS

@Suite("LoginViewModel")
@MainActor
struct LoginViewModelTests {

    private func makeSession() -> UserSession {
        UserSession(username: "testUser", documentId: "12345", name: "Juan Test")
    }

    // MARK: Happy path

    @Test func login_setsSuccessState_onValidCredentialsAndSuccessfulUseCase() async {
        let useCase = MockLoginUseCase(session: makeSession())
        let sut = LoginViewModel(useCase: useCase)

        await sut.login()

        #expect(sut.state == .success)
    }

    @Test func login_storesSession_afterSuccessfulLogin() async {
        let expected = makeSession()
        let useCase = MockLoginUseCase(session: expected)
        let sut = LoginViewModel(useCase: useCase)

        await sut.login()

        #expect(sut.session == expected)
    }

    // MARK: Validation guard

    @Test func login_setsFailedState_whenUsuarioIsEmpty() async {
        let useCase = MockLoginUseCase(session: makeSession())
        let sut = LoginViewModel(useCase: useCase)
        sut.username = ""

        await sut.login()

        if case .failed(let message) = sut.state {
            #expect(message == "Ingresa usuario y contraseña para continuar.")
        } else {
            Issue.record("Expected .failed state, but got \(sut.state)")
        }
    }

    @Test func login_setsFailedState_whenPasswordIsEmpty() async {
        let useCase = MockLoginUseCase(session: makeSession())
        let sut = LoginViewModel(useCase: useCase)
        sut.password = ""

        await sut.login()

        if case .failed = sut.state { } else {
            Issue.record("Expected .failed state, but got \(sut.state)")
        }
    }

    @Test func login_doesNotCallUseCase_whenUserOrPasswordIsEmpty() async {
        // If the guard fires, the use case should never be called.
        // A successful use case would set state = .success; with an empty user
        // we expect .failed, which means the use case was NOT called.
        let useCase = MockLoginUseCase(session: makeSession())
        let sut = LoginViewModel(useCase: useCase)
        sut.username = ""

        await sut.login()

        // If use case had been called, state would be .success.
        #expect(sut.state != .success)
    }

    // MARK: Network error

    @Test func login_setsFailedState_onNetworkError() async {
        let useCase = MockLoginUseCase(error: NetworkError.status(401))
        let sut = LoginViewModel(useCase: useCase)

        await sut.login()

        if case .failed = sut.state { } else {
            Issue.record("Expected .failed state, but got \(sut.state)")
        }
    }

    @Test func login_doesNotStoreSession_onNetworkError() async {
        let useCase = MockLoginUseCase(error: NetworkError.status(401))
        let sut = LoginViewModel(useCase: useCase)

        await sut.login()

        #expect(sut.session == nil)
    }

    // MARK: Unexpected error

    @Test func login_setsGenericFailedMessage_onUnexpectedError() async {
        struct SomeError: Error {}
        let useCase = MockLoginUseCase(error: SomeError())
        let sut = LoginViewModel(useCase: useCase)

        await sut.login()

        if case .failed(let message) = sut.state {
            #expect(message == "Error inesperado. Intenta de nuevo.")
        } else {
            Issue.record("Expected .failed state, but got \(sut.state)")
        }
    }

    // MARK: Default field values

    @Test func defaultState_isIdle() {
        let sut = LoginViewModel(useCase: MockLoginUseCase())
        #expect(sut.state == .idle)
    }

    @Test func defaultSession_isNil() {
        let sut = LoginViewModel(useCase: MockLoginUseCase())
        #expect(sut.session == nil)
    }
}
