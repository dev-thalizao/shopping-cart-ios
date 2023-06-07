//
//  ProductsViewModelTests.swift
//  
//
//  Created by Thales Frigo on 06/06/23.
//

import XCTest
import Combine
@testable import Marketplace

final class ProductsViewModelTests: XCTestCase {
    
    func test_init_doesNotTriggerAnyRequest() throws {
        let (sut, _) = makeSUT()
        XCTAssertEqual(sut.products, [])
    }
    
    func test_loadProducts_returnProductsWithSuccessRequest() async throws {
        let (sut, loader) = makeSUT()
        loader.completion = { .success([makeDressProduct()]) }

        let spy = TestObserver(sut.$products)
        
        try await sut.loadProducts()

        XCTAssertEqual(spy.values, [[makeDressProduct()]])
    }
}

// MARK: - Helpers

private func makeSUT() -> (ProductsViewModel, StubProductsLoader) {
    let loader = StubProductsLoader()
    let viewModel = ProductsViewModel(loader: loader)
    return (viewModel, loader)
}

private class StubProductsLoader: ProductsLoader {
    
    var completion: (() -> Result<[Product], Error>)!
    
    func load() async throws -> [Product] {
        return try await withCheckedThrowingContinuation({ continuation in
            continuation.resume(with: completion())
        })
    }
}

private func makeDressProduct() -> Product {
    return Product(
        name: "VESTIDO TRANSPASSE BOW",
        image: URL(string: "https://d3l7rqep7l31az.cloudfront.net/images/products/20002605_615_catalog_1.jpg?1460136912")!,
        onSale: false,
        regularPrice: "R$ 199,90",
        actualPrice: "R$ 199,90",
        discountPercentage: "",
        installments: "3x R$ 66,63",
        sizes: [
            Product.Size(available: false, size: "PP", sku: "5807_343_0_PP"),
            Product.Size(available: true, size: "P", sku: "5807_343_0_P"),
            Product.Size(available: true, size: "M", sku: "5807_343_0_M"),
            Product.Size(available: true, size: "G", sku: "5807_343_0_G"),
            Product.Size(available: false, size: "GG", sku: "5807_343_0_GG"),
        ]
    )
}
