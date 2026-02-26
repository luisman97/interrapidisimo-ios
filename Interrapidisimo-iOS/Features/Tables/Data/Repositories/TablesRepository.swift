//
//  TablesRepository.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import Foundation

struct TablesRepository: TablesRepositoryProtocol {
    private let httpClient: HTTPClientProtocol

    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }

    func fetchSchemas(user: String) async throws(NetworkError) -> [TableSchema] {
        let dtos: [TableSchemaDTO] = try await httpClient.request(service: .tables(user: user))
        return dtos.map(\.toDomain)
    }
}
