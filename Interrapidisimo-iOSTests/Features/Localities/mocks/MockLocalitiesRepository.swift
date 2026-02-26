//
//  MockLocalitiesRepository.swift
//  Interrapidisimo-iOSTests
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import Foundation
@testable import Interrapidisimo_iOS

final class MockLocalitiesRepository: LocalitiesRepositoryProtocol {
    var localitiesToReturn: [Locality]
    var errorToThrow: NetworkError?

    init(localities: [Locality] = [], error: NetworkError? = nil) {
        self.localitiesToReturn = localities
        self.errorToThrow = error
    }

    func fetchLocalities() async throws(NetworkError) -> [Locality] {
        if let error = errorToThrow { throw error }
        return localitiesToReturn
    }
}
