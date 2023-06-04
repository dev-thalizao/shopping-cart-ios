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
}
