//
//  FetchLocalitiesUseCase.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

protocol FetchLocalitiesUseCaseProtocol {
    func execute() async throws(NetworkError) -> [Locality]
}

struct FetchLocalitiesUseCase: FetchLocalitiesUseCaseProtocol {
    private let repository: LocalitiesRepositoryProtocol

    init(repository: LocalitiesRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws(NetworkError) -> [Locality] {
        try await repository.fetchLocalities()
    }
}
