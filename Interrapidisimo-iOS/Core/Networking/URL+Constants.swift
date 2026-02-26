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
    static let securityBaseURL = URL(string: "https://apitesting.interrapidisimo.co/FtEntregaElectronica/MultiCanales/ApiSeguridadPruebas/api")!
}

// MARK: - VersionCheck endpoints

extension URL {
    static let versionCheck = interrapidisimoBaseURL
        .appending(path: "ParametrosFramework/ConsultarParametrosFramework/VPStoreAppControl")
}

// MARK: - Login endpoints

extension URL {
    static let login = securityBaseURL
        .appending(path: "Seguridad/AuthenticaUsuarioApp")
}

// MARK: - Tables endpoints

extension URL {
    static let fetchSchema = interrapidisimoBaseURL
        .appending(path: "SincronizadorDatos/ObtenerEsquema/true")
}

// MARK: - Localities endpoints

extension URL {
    static let fetchPickupLocalities = interrapidisimoBaseURL
        .appending(path: "ParametrosFramework/ObtenerLocalidadesRecogidas")
}

// MARK: - App links

extension URL {
    static let appStore = URL(string: "https://apps.apple.com/us/app/id945717986")
}
