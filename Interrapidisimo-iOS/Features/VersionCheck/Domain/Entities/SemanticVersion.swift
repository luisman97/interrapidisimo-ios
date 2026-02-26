//
//  SemanticVersion.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

struct SemanticVersion: Comparable {
    let major: Int
    let minor: Int
    let patch: Int

    init?(_ string: String) {
        let parts = string.split(separator: ".").compactMap { Int($0) }
        guard !parts.isEmpty else { return nil }
        major = parts[0]
        minor = parts.count > 1 ? parts[1] : 0
        patch = parts.count > 2 ? parts[2] : 0
    }

    static func < (
        lhs: SemanticVersion,
        rhs: SemanticVersion
    ) -> Bool {
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        return lhs.patch < rhs.patch
    }
}
