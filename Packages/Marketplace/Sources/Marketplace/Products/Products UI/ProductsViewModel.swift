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
    @Published private(set) var state = State.initial
    
    private let loader: ProductsLoader
    
    public init(loader: ProductsLoader) {
        self.loader = loader
    }
    
     @MainActor func loadProducts() async {
         self.state = .loading
         
         do {
             let products = try await loader.load()
             self.state = .success(products)
         } catch {
             self.state = .failure
         }
    }
}

extension ProductsViewModel {
    
    enum State: Equatable {
        case initial
        case loading
        case success([Product])
        case failure
    }
}
