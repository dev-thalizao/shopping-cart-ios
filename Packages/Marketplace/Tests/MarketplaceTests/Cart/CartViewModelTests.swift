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
        let sut = CartViewModel()
        XCTAssertEqual(sut.items, [])
        XCTAssertEqual(sut.totalPrice, 0)
    }
    
    func test_add_triggerChangesOnPrice() {
        let sut = CartViewModel()
        let priceSpy = TestObserver(sut.$totalPrice)
        
        let selectedProduct = (makeDressProduct(), makeGAvailableSize())
        
        sut.add(selectedProduct)
        
        XCTAssertEqual(priceSpy.values, [199.90])
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
