//
//  LocalitiesRepositoryProtocol.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

protocol LocalitiesRepositoryProtocol {
    func fetchLocalities() async throws(NetworkError) -> [Locality]
}
