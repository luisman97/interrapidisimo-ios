//
//  APIRouter.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 26/02/26.
//

import Foundation

enum APIRouter {
    case localities
    case login(LoginRequestDTO, [String: String])
    case tables(user: String)
    case remoteVersion

    /// Creates a configured `URLRequest` for the API endpoint.
    ///
    /// This method constructs a URL request by combining the router's URL, HTTP method,
    /// and headers, then attaches the request body if applicable.
    ///
    /// - Returns: A fully configured `URLRequest` ready to be executed.
    /// - Throws: `NetworkError.json` if encoding the request body fails.
    func request() throws -> URLRequest {
        var request = URLRequest.make(url, method: method, headers: headers)
        request.httpBody = try body()
        return request
    }
}

// MARK: - Private Computed Properties

private extension APIRouter {
    var method: HTTPMethod {
        switch self {
        case .localities, .tables, .remoteVersion:
            return .get
        case .login:
            return .post
        }
    }

    var url: URL {
         switch self {
         case .localities: .fetchPickupLocalities
         case .login: .login
         case .tables: .fetchSchema
         case .remoteVersion: .versionCheck
         }
     }

    var headers: [String: String] {
        switch self {
        case .localities, .remoteVersion:
            return [:]
        case .tables(let user):
            return ["Usuario": user]
        case .login(_, let headers):
            return headers
        }
    }
}

// MARK: - Private Methods

private extension APIRouter {
    func body() throws -> Data? {
        switch self {
        case .localities, .tables, .remoteVersion:
            return nil
        case .login(let bodyDTO, _):
            do {
                return try JSONEncoder().encode(bodyDTO)
            } catch {
                throw NetworkError.json(error)
            }
        }
    }
}
