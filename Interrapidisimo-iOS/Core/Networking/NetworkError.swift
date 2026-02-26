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

    /// A localized description of the network error.
    ///
    /// This property provides user-facing error messages for different network failure scenarios.
    /// Each case returns a localized string that describes the specific error condition.
    ///
    /// - Returns: A localized string describing the error, or `nil` if no description is available.
    ///
    /// The possible error descriptions include:
    /// - `.general`: A general error with the underlying error's localized description
    /// - `.status`: An HTTP status code error with the specific code
    /// - `.json`: A JSON parsing error with the underlying error's localized description
    /// - `.dataNotValid`: An error indicating invalid data was received from the server
    /// - `.nonHTTP`: An error indicating the response was not an HTTP response
    /// - `.invalidResponse`: An error indicating the response contains no usable data
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
