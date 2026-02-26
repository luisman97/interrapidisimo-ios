//
//  NetworkManager.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import Foundation
import OSLog

private let networkLogger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "com.interrapidisimo",
    category: "network"
)

protocol HTTPClientProtocol {
    func request<T: Decodable>(service: APIRouter) async throws(NetworkError) -> T
}

struct HTTPClient: HTTPClientProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Performs an asynchronous network request and decodes the response into the specified type.
    ///
    /// This method creates a `URLRequest` from the provided `APIRouter` service, executes it,
    /// validates the HTTP response status code, and decodes the response data into the generic type `T`.
    ///
    /// - Parameter service: An `APIRouter` case representing the API endpoint to call. The router
    ///   provides the URL, HTTP method, headers, and request body for the request.
    ///
    /// - Returns: A decoded instance of type `T` conforming to `Decodable`, parsed from the response data.
    ///
    /// - Throws: A `NetworkError` if any of the following conditions occur:
    ///   - The `APIRouter` fails to construct a valid `URLRequest` (propagates `.json` or `.general`)
    ///   - The network request fails (`.general` wrapping the underlying error)
    ///   - The response is not an `HTTPURLResponse` (`.nonHTTP`)
    ///   - The HTTP status code is not 200 (`.status` with the actual status code)
    ///   - JSON decoding fails (`.json` wrapping the decoding error)
    ///
    /// The method logs the request URL and response status code using `OSLog` for debugging purposes.
    /// Only responses with a 200 status code are considered successful; all other status codes result
    /// in a thrown error.
    ///
    /// ## Usage Example
    /// ```swift
    /// let client = HTTPClient()
    /// let localities: [LocalityDTO] = try await client.request(service: .localities)
    /// ```
    func request<T: Decodable>(service: APIRouter) async throws(NetworkError) -> T {
        let request: URLRequest
        do {
            request = try service.request()
        } catch let error as NetworkError {
            throw error
        } catch {
            throw .general(error)
        }
        networkLogger.debug(
            "Request URL: \(request.url?.absoluteString ?? "Unknown URL", privacy: .public)"
        )
        let (data, httpResponse) = try await session.getData(for: request)
        networkLogger.debug("Response StatusCode: \(httpResponse.statusCode)")
        guard httpResponse.statusCode == 200 else {
            networkLogger.error("Response error: \(httpResponse.statusCode)")
            throw NetworkError.status(httpResponse.statusCode)
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.json(error)
        }
    }
}
