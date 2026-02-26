//
//  LoginUseCase.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

protocol LoginUseCaseProtocol {
    func execute(credentials: LoginCredentials) async throws -> UserSession
}

struct LoginUseCase: LoginUseCaseProtocol {
    private let loginRepository: LoginRepositoryProtocol
    private let sessionRepository: UserSessionRepositoryProtocol

    init(
        loginRepository: LoginRepositoryProtocol,
        sessionRepository: UserSessionRepositoryProtocol
    ) {
        self.loginRepository = loginRepository
        self.sessionRepository = sessionRepository
    }

    func execute(credentials: LoginCredentials) async throws -> UserSession {
        let session = try await loginRepository.login(credentials: credentials)
        try await sessionRepository.save(session)
        return session
    }
}
