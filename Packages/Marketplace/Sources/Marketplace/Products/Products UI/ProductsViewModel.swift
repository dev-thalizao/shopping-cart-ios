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
    @Published private(set) var filter = Filter.all
    
    private var productsCache = [Product]()
    
    var canFilter: Bool {
        if case let .success(products) = state, !products.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    private let loader: ProductsLoader
    
    public init(loader: ProductsLoader) {
        self.loader = loader
    }
    
    @MainActor func loadProducts() async {
        self.state = .loading
        
        do {
            let products = try await loader.load()
            self.state = .success(products)
            self.productsCache = products
        } catch {
            self.state = .failure
            self.productsCache.removeAll()
        }
    }
    
    func applyFilter(_ filter: Filter) {
        self.filter = filter
        switch filter {
        case .onSale:
            self.state = .success(productsCache.filter(\.onSale))
        case .all:
            self.state = .success(productsCache)
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
    
    enum Filter {
        case all
        case onSale
    }
}
