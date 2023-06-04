import XCTest
@testable import CartEngine

open class Cart {
    public private(set) var items = [Any]()
    
    public func add(_ product: String) {
        items.append(product)
    }
}

final class CartTests: XCTestCase {
    
    func test_init_startsWithNoItems() {
        XCTAssertTrue(Cart().items.isEmpty)
    }
    
    func test_add_insertsOneItem() {
        let cart = Cart()
        cart.add("pizza")
        XCTAssertEqual(cart.items.count, 1)
    }
}
