//
//  ProductsLoader.swift
//  
//
//  Created by Thales Frigo on 08/06/23.
//

import Foundation

public protocol ProductsLoader {
    func load() async throws -> [Product]
}
