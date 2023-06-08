//
//  HTTPClient.swift
//
//
//  Created by Thales Frigo on 08/06/23.
//

import Foundation

/// A simple protocol to executing HTTP request
public protocol HTTPClient {
    
    /**
     * Executes a request and return the following data and resposne
     * If the product already exists, increment the quantity.
     *
     * - parameter request: The request to be executed.
     *
     * - Returns: The data and the response
     */
    func execute(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
}
