//
//  URLSession+getData.swift
//  Interrapidisimo-iOS
//
//  Created by Jorge Luis Rivera on 25/02/26.
//

import Foundation

extension URLSession {

    /// Performs an asynchronous data task with the specified URL request and returns typed HTTP response data.
    ///
    /// This method wraps the standard `URLSession.data(for:)` method to provide stronger type safety by
    /// ensuring the response is an `HTTPURLResponse` and using typed throws for error handling.
    ///
    /// - Parameter request: The URL request to perform.
    /// - Returns: A tuple containing the downloaded data and the HTTP response.
    /// - Throws: A `NetworkError` if the request fails, the response is not HTTP, or another error occurs.
    ///
    /// ## Example
    /// ```swift
    /// let url = URL(string: "https://api.example.com/data")!
    /// let request = URLRequest(url: url)
    /// 
    /// do {
    ///     let (data, response) = try await URLSession.shared.getData(for: request)
    ///     print("Status code: \(response.statusCode)")
    /// } catch {
    ///     print("Request failed: \(error)")
    /// }
    /// ```
    func getData(for request: URLRequest) async throws(NetworkError) -> (
        data: Data,
        response: HTTPURLResponse
    ) {
        do {
            let (data, response) = try await data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.nonHTTP
            }
            return (data, httpResponse)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw .general(error)
        }
    }
}
