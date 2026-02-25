//
//  Bundle+AppVersion.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import Foundation

extension Bundle {
    /// Marketing version (CFBundleShortVersionString), e.g. "1.0.0".
    /// Falls back to "0" if the key is absent so SemanticVersion parsing never crashes.
    var appVersion: String {
        object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0"
    }
}
