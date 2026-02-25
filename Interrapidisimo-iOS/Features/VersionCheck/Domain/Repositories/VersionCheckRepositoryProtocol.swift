//
//  VersionCheckRepositoryProtocol.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

protocol VersionCheckRepositoryProtocol {
    func fetchRemoteVersion() async throws -> String
}
