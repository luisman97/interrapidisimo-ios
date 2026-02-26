//
//  URLRequest+Builders.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

extension URLRequest {

    /// Creates a configured `URLRequest` with standard JSON headers.
    ///
    /// This method constructs a `URLRequest` with the specified URL and HTTP method,
    /// automatically setting JSON content type headers and a 60-second timeout.
    ///
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - method: The HTTP method to use (GET, POST, PUT, PATCH, or DELETE).
    ///   - headers: Additional HTTP headers to include in the request. Default is an empty dictionary.
    ///
    /// - Returns: A configured `URLRequest` instance with:
    ///   - The specified HTTP method
    ///   - A 60-second timeout interval
    ///   - "Accept" header set to "application/json"
    ///   - "Content-Type" header set to "application/json; charset=utf-8"
    ///   - Any additional headers provided in the `headers` parameter
    static func make(
        _ url: URL,
        method: HTTPMethod,
        headers: [String: String] = [:]
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 60
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}
