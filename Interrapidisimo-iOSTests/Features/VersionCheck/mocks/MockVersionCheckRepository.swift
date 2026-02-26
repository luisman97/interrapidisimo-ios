//
//  MockVersionCheckRepository.swift
//  Interrapidisimo-iOSTests
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import Foundation
@testable import Interrapidisimo_iOS

final class MockVersionCheckRepository: VersionCheckRepositoryProtocol {
    var versionToReturn: String
    var errorToThrow: Error?

    init(version: String = "1.0.0", error: Error? = nil) {
        self.versionToReturn = version
        self.errorToThrow = error
    }

    func fetchRemoteVersion() async throws -> String {
        if let error = errorToThrow { throw error }
        return versionToReturn
    }
}
