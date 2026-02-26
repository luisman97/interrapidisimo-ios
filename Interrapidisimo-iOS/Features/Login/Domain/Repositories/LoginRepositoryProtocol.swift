//
//  LoginRepositoryProtocol.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

protocol LoginRepositoryProtocol {
    func login(credentials: LoginCredentials) async throws(NetworkError) -> UserSession
}
