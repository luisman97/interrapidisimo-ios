//
//  VersionCheckResult.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import Foundation

enum VersionStatus: Equatable {
    case upToDate
    case updateAvailable(remoteVersion: String)
    case versionAhead(remoteVersion: String)
}
