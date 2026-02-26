//
//  UserSessionRepositoryProtocol.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

protocol UserSessionRepositoryProtocol {
    func save(_ session: UserSession) async throws
    func currentSession() async throws -> UserSession?
    func clearSession() async throws
}
