//
//  ProductsViewModel.swift
//  
//
//  Created by Thales Frigo on 06/06/23.
//

import Foundation

public protocol ProductsLoader {
    func load() async throws -> [Product]
}

 public class ProductsViewModel: ObservableObject {
    
    @Published private(set) var products = [Product]()
    
    private let loader: ProductsLoader
    
    public init(loader: ProductsLoader) {
        self.loader = loader
    }
    
     @MainActor func loadProducts() async throws {
         self.products = try await loader.load()
    }
}
