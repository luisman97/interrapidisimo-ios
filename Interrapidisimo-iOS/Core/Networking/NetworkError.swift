//
//  NetworkError.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import Foundation

enum NetworkError: LocalizedError {
    case general(Error)
    case status(Int)
    case json(Error)
    case dataNotValid
    case nonHTTP
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .general(let error): String(localized: "General: \(error.localizedDescription)")
        case .status(let code): String(localized: "HTTP status code: \(code)")
        case .json(let error): String(localized: "JSON error: \(error.localizedDescription)")
        case .dataNotValid: String(localized: "Invalid data received from server")
        case .nonHTTP: String(localized: "URLSession did not return a HTTPURLResponse")
        case .invalidResponse: String(localized: "Response is valid but contains no usable data")
        }
    }
}
