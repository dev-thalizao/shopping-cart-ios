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
    
    
}
