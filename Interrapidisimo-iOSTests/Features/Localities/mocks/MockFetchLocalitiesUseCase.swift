//
//  MockFetchLocalitiesUseCase.swift
//  Interrapidisimo-iOSTests
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import Foundation
@testable import Interrapidisimo_iOS

final class MockFetchLocalitiesUseCase: FetchLocalitiesUseCaseProtocol {
    var localitiesToReturn: [Locality]
    var errorToThrow: NetworkError?

    init(localities: [Locality] = [], error: NetworkError? = nil) {
        self.localitiesToReturn = localities
        self.errorToThrow = error
    }

    func execute() async throws(NetworkError) -> [Locality] {
        if let error = errorToThrow { throw error }
        return localitiesToReturn
    }
}
