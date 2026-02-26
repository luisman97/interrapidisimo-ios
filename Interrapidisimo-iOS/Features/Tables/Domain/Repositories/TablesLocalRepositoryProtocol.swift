//
//  TablesLocalRepositoryProtocol.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

protocol TablesLocalRepositoryProtocol {
    func saveSchemas(_ schemas: [TableSchema]) async throws
}
