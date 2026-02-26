//
//  LoginRepository.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import Foundation

struct LoginRepository: LoginRepositoryProtocol {
    private let httpClient: HTTPClientProtocol
    private let sourceApplicationId = "9"

    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }

    func login(credentials: LoginCredentials) async throws(NetworkError) -> UserSession {
        let dto: LoginResponseDTO = try await httpClient.request(
            service: .login(
                buildBody(from: credentials),
                buildHeaders(from: credentials)
            )
        )
        return UserSession(
            username: dto.username,
            documentId: dto.documentId,
            name: dto.firstName
        )
    }
}

// MARK: - Private Methods

private extension LoginRepository {
    func buildHeaders(from credentials: LoginCredentials) -> [String: String] {
        [
            "Usuario": credentials.username,
            "Identificacion": credentials.documentId,
            "IdUsuario": credentials.username,
            "IdCentroServicio": credentials.serviceOfficeId,
            "NombreCentroServicio": credentials.serviceOfficeName,
            "IdAplicativoOrigen": sourceApplicationId,
            "Accept": "text/json"
        ]
    }

    func buildBody(from credentials: LoginCredentials) -> LoginRequestDTO {
        LoginRequestDTO(
            encodedUsername: base64(credentials.username),
            encodedPassword: base64(credentials.password)
        )
    }

    func base64(_ value: String) -> String {
        Data(value.utf8).base64EncodedString()
    }
}
