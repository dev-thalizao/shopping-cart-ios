//
//  CartViewModelTests.swift
//  
//
//  Created by Thales Frigo on 08/06/23.
//

import XCTest
@testable import Marketplace

final class CartViewModelTests: XCTestCase {

    func test_init_doesNotTriggerAnyChanges() {
        let sut = makeSUT()
        XCTAssertEqual(sut.items, [])
        XCTAssertEqual(sut.totalPrice, 0)
    }
    
    func test_select_triggerChangesOnPrice() {
        let sut = makeSUT()
        let priceSpy = TestObserver(sut.$totalPrice)
        
        sut.select(makeDressProduct(), with: makeGAvailableSize())
        
        XCTAssertEqual(priceSpy.values, [199.90])
        
        sut.select(makeDressProduct(), with: makeGAvailableSize())

        XCTAssertEqual(priceSpy.values, [199.90, 399.80])
    }
    
    func test_select_triggerChangesOnItems() {
        let sut = makeSUT()
        let itemsSpy = TestObserver(sut.$items)
        
        sut.select(makeDressProduct(), with: makeGAvailableSize())
        
        XCTAssertEqual(itemsSpy.values, [[
            CartItemViewModel(
                product: .init(product: makeDressProduct(), size: makeGAvailableSize()),
                quantity: 1,
                increase: {},
                decrease: {}
            )
        ]])
    }
    
    func test_increase_incrementsTheQuantity() throws {
        let sut = makeSUT()
        let itemsSpy = TestObserver(sut.$items)
        
        sut.select(makeDressProduct(), with: makeGAvailableSize())
        
        XCTAssertEqual(itemsSpy.values, [[
            makeCartItemViewModel(quantity: 1)
        ]])
        
        let cartItemViewModel = try XCTUnwrap(itemsSpy.values.first?.first)
        
        cartItemViewModel.increase()
        
        XCTAssertEqual(itemsSpy.values, [
            [makeCartItemViewModel(quantity: 1)],
            [makeCartItemViewModel(quantity: 2)]
        ])
    }
    
    func test_decreases_decreasesTheQuantity() throws {
        let sut = makeSUT()
        let itemsSpy = TestObserver(sut.$items)
        
        sut.select(makeDressProduct(), with: makeGAvailableSize())
        sut.select(makeDressProduct(), with: makeGAvailableSize())
        
        XCTAssertEqual(itemsSpy.values, [
            [makeCartItemViewModel(quantity: 1)],
            [makeCartItemViewModel(quantity: 2)]
        ])
        
        let cartItemViewModel = try XCTUnwrap(itemsSpy.values.first?.first)
        
        cartItemViewModel.decrease()
        
        XCTAssertEqual(itemsSpy.values, [
            [makeCartItemViewModel(quantity: 1)],
            [makeCartItemViewModel(quantity: 2)],
            [makeCartItemViewModel(quantity: 1)],
        ])
        
        cartItemViewModel.decrease()
        
        XCTAssertEqual(itemsSpy.values, [
            [makeCartItemViewModel(quantity: 1)],
            [makeCartItemViewModel(quantity: 2)],
            [makeCartItemViewModel(quantity: 1)],
            []
        ])
    }
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> CartViewModel {
        let sut = CartViewModel()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    func test_formatter() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "BRL"
        formatter.positivePrefix = "R$ "
        
        XCTAssertEqual(formatter.number(from: "R$ 199,90")?.doubleValue, 199.90)
        XCTAssertEqual(formatter.string(from: NSNumber(value: 1999.90)), "R$ 1.999,90")
    }
}

private func makeCartItemViewModel(
    product:ProductWithSize = .init(product: makeDressProduct(), size: makeGAvailableSize()),
    quantity: UInt = 1
) -> CartItemViewModel {
    return CartItemViewModel(
        product: .init(product: makeDressProduct(), size: makeGAvailableSize()),
        quantity: quantity,
        increase: {},
        decrease: {}
    )
}

private func makeGAvailableSize() -> Product.AvailableSize {
    return Product.AvailableSize(size: "G", sku: "5807_343_0_G")
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

extension XCTestCase {
    
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
