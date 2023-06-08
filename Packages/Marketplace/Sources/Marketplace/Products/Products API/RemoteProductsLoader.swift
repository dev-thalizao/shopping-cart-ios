//
//  File.swift
//  
//
//  Created by Thales Frigo on 08/06/23.
//

import Foundation
import NetworkEngine

public final class RemoteProductsLoader: ProductsLoader {
    
    private let httpClient: HTTPClient
    private let resourceURL: URL
    
    public init(httpClient: HTTPClient, resourceURL: URL) {
        self.httpClient = httpClient
        self.resourceURL = resourceURL
    }
    
    public func load() async throws -> [Product] {
        let request = URLRequest(url: resourceURL)
        let (data, response) = try await httpClient.execute(request)
        let products = try ProductsMapper.map(data, from: response)
        
        return products
    }
}
