//
//  TablesRepositoryProtocol.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

protocol TablesRepositoryProtocol {
    func fetchSchemas(user: String) async throws(NetworkError) -> [TableSchema]
}
