import XCTest
@testable import CartEngine

open class Cart {

    private(set) var items = [Item]()
    
    public func add(_ product: String) {
        for (index, item) in items.enumerated() {
            if item.product == product {
                items[index] = .init(product: product, quantity: item.quantity + 1)
                return
            }
        }
        
        items.append(.init(product: product, quantity: 1))
    }
    
    public func remove(_ product: String) {
        for (index, item) in items.enumerated() {
            if item.product == product {
                let newQuantity = max(0, item.quantity - 1)
                if newQuantity >= 1 {
                    items[index] = .init(product: product, quantity: newQuantity)
                } else {
                    items.remove(at: index)
                }
                return
            }
        }
    }
}

extension Cart {
    
    struct Item {
        let product: String
        let quantity: UInt
    }
}

final class CartTests: XCTestCase {
    
    func test_init_startsWithNoItems() {
        XCTAssertTrue(Cart().items.isEmpty)
    }
    
    func test_add_withoutExistingItem_addsNewOne() {
        let cart = Cart()
        cart.add("pizza")
        XCTAssertEqual(cart.items.count, 1)
        XCTAssertEqual(cart.items[0].quantity, 1)
    }
    
    func test_add_withExistingItem_incrementTheQuantity() {
        let cart = Cart()
        cart.add("pizza")
        cart.add("pizza")
        XCTAssertEqual(cart.items.count, 1)
        XCTAssertEqual(cart.items[0].quantity, 2)
    }
    
    func test_remove_withOnlyOneAsQuantity_removeTheItem() {
        let cart = Cart()
        cart.add("meat")
        
        cart.remove("meat")
        
        XCTAssertTrue(cart.items.isEmpty)
    }
    
    func test_remove_withMoreThanOneQuantity_decreaseTheQuantity() {
        let cart = Cart()
        cart.add("meat")
        cart.add("meat")
        cart.add("meat")
        
        cart.remove("meat")
        
        XCTAssertEqual(cart.items.count, 1)
        XCTAssertEqual(cart.items[0].quantity, 2)
    }
}
