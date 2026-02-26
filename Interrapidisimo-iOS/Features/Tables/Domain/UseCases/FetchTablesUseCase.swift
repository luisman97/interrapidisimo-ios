//
//  FetchTablesUseCase.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

protocol FetchTablesUseCaseProtocol {
    func execute(username: String) async throws -> [TableSchema]
}

struct FetchTablesUseCase: FetchTablesUseCaseProtocol {
    private let remoteRepository: TablesRepositoryProtocol
    private let localRepository: TablesLocalRepositoryProtocol

    init(
        remoteRepository: TablesRepositoryProtocol,
        localRepository: TablesLocalRepositoryProtocol
    ) {
        self.remoteRepository = remoteRepository
        self.localRepository = localRepository
    }

    func execute(username: String) async throws -> [TableSchema] {
        let schemas = try await remoteRepository.fetchSchemas(user: username)
        try await localRepository.saveSchemas(schemas)
        return schemas
    }
}
