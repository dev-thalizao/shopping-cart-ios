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
                cartProduct: .init(product: makeDressProduct(), size: makeGAvailableSize()),
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
    
    func test_clear_removeAllItems() throws {
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
        
        sut.clear()
        
        XCTAssertEqual(itemsSpy.values, [
            [makeCartItemViewModel(quantity: 1)],
            [makeCartItemViewModel(quantity: 2)],
            []
        ])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> CartViewModel {
        let sut = CartViewModel()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
