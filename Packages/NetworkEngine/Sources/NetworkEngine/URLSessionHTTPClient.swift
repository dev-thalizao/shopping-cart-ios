//
//  File.swift
//  
//
//  Created by Thales Frigo on 08/06/23.
//

import Foundation

/// The default implementation of the HTTPClient
public final class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    public struct UnexpectedValuesRepresentation: Error {}
    
    public func execute(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw UnexpectedValuesRepresentation()
        }
        
        return (data, httpResponse)
    }
}
