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
    
    func test_init_doesNotTriggerAnyChanges() throws {
        let (sut, _) = makeSUT()
        XCTAssertEqual(sut.state, .initial)
        XCTAssertEqual(sut.filter, .all)
    }
    
    func test_loadProducts_returnProductsWithSuccessRequest() async throws {
        let (sut, loader) = makeSUT()
        loader.completion = { .success([makeDressProduct()]) }

        let spy = TestObserver(sut.$state)
        
        await sut.loadProducts()

        XCTAssertEqual(spy.values, [
            .loading,
            .success([makeDressProduct()])
        ])
    }
    
    func test_loadProducts_returnErrorWithFailedRequest() async throws {
        let (sut, loader) = makeSUT()
        loader.completion = { .failure(AnyError()) }

        let spy = TestObserver(sut.$state)

        await sut.loadProducts()

        XCTAssertEqual(spy.values, [.loading, .failure])
    }
    
    func test_canFilter_onlyIsEnabledWithProducts() async throws {
        let (sut, loader) = makeSUT()
        loader.completion = { .success([makeDressProduct()]) }
        
        XCTAssertEqual(sut.canFilter, false, "pre-condition")
        
        await sut.loadProducts()

        XCTAssertEqual(sut.canFilter, true)
    }
    
    func test_applyFilter_returnFilteredProducts() async throws {
        let (sut, loader) = makeSUT()
        loader.completion = { .success([makeDressProduct(onSale: true), makeDressProduct(onSale: false)]) }

        let spy = TestObserver(sut.$state)
        
        await sut.loadProducts()

        XCTAssertEqual(spy.values, [
            .loading,
            .success([makeDressProduct(onSale: true), makeDressProduct(onSale: false)])
        ])
        
        sut.applyFilter(.onSale)
        
        XCTAssertEqual(spy.values, [
            .loading,
            .success([makeDressProduct(onSale: true), makeDressProduct(onSale: false)]),
            .success([makeDressProduct(onSale: true)])
        ])
            
        sut.applyFilter(.all)
            
        XCTAssertEqual(spy.values, [
            .loading,
            .success([makeDressProduct(onSale: true), makeDressProduct(onSale: false)]),
            .success([makeDressProduct(onSale: true)]),
            .success([makeDressProduct(onSale: true), makeDressProduct(onSale: false)]),
        ])
    }
}

// MARK: - Helpers

struct AnyError: Error {}

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
