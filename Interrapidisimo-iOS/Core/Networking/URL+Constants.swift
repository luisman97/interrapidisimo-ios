//
//  URL+Constants.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import Foundation

// MARK: - Base URLs

private extension URL {
    static let interrapidisimoBaseURL = URL(string: "https://apitesting.interrapidisimo.co/apicontrollerpruebas/api")!
}

// MARK: - VersionCheck endpoints

extension URL {
    static let versionCheck = interrapidisimoBaseURL
        .appending(path: "ParametrosFramework/ConsultarParametrosFramework/VPStoreAppControl")
}

// MARK: - App links

extension URL {
    static let appStore = URL(string: "https://apps.apple.com/us/app/id945717986")
}
