//
//  LocalitiesRepository.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import Foundation

struct LocalitiesRepository: LocalitiesRepositoryProtocol {
    private let httpClient: HTTPClientProtocol

    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }

    func fetchLocalities() async throws(NetworkError) -> [Locality] {
        let dtos: [LocalityDTO] = try await httpClient.request(service: .localities)
        return dtos.map(\.toDomain)
    }
}
