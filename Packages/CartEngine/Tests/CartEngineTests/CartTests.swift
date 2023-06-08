import XCTest
@testable import CartEngine

final class CartTests: XCTestCase {
    
    func test_init_startsWithNoItems() {
        XCTAssertTrue(makeSUT().items.isEmpty)
    }
    
    func test_add_withoutExistingItem_addsNewOne() {
        let cart = makeSUT()
        cart.add(.pizza)
        XCTAssertEqual(cart.items.count, 1)
        XCTAssertEqual(cart.items[0].quantity, 1)
    }
    
    func test_add_withExistingItem_incrementTheQuantity() {
        let cart = makeSUT()
        cart.add(.pizza)
        cart.add(.pizza)
        XCTAssertEqual(cart.items.count, 1)
        XCTAssertEqual(cart.items[0].quantity, 2)
    }
    
    func test_remove_withOnlyOneAsQuantity_removeTheItem() {
        let cart = makeSUT()
        cart.add(.meat)
        
        cart.remove(.meat)
        
        XCTAssertTrue(cart.items.isEmpty)
    }
    
    func test_remove_withMoreThanOneQuantity_decreaseTheQuantity() {
        let cart = makeSUT()
        cart.add(.meat)
        cart.add(.meat)
        cart.add(.meat)
        
        cart.remove(.meat)
        
        XCTAssertEqual(cart.items.count, 1)
        XCTAssertEqual(cart.items[0].quantity, 2)
    }
    
    func test_totalPrice_sumsTheMultiplicationOfProductByQuantity() {
        let cart = makeSUT()
        cart.add(.meat)
        cart.add(.meat)
        cart.add(.pizza)

        XCTAssertEqual(cart.totalPrice, 28)
    }
    
    func test_totalItems_sumsAllTheQuantities() {
        let cart = makeSUT()
        cart.add(.meat)
        cart.add(.meat)
        cart.add(.pizza)

        XCTAssertEqual(cart.items.count, 2)
        XCTAssertEqual(cart.totalItems, 3)
    }
    
    func test_clear_removeAllItems() {
        let cart = makeSUT()
        cart.add(.meat)
        cart.add(.meat)
        cart.add(.pizza)

        XCTAssertEqual(cart.items.count, 2)
        XCTAssertEqual(cart.totalItems, 3)
        
        cart.clear()
        
        XCTAssertEqual(cart.items.count, 0)
        XCTAssertEqual(cart.totalItems, 0)
    }
    
    func test_delegate_notifiesAllChangesInItems() {
        let cart = makeSUT()
        let spy = SpyFoodChanges()
        cart.onCartChange = spy.cartDidChange(_:)
        
        cart.add(.pizza)
        cart.add(.pizza)
        cart.add(.meat)
        cart.remove(.meat)
        cart.remove(.pizza)
        cart.clear()
        
        XCTAssertEqual(spy.items, [
            [.init(product: .pizza, quantity: 1)],
            [.init(product: .pizza, quantity: 2)],
            [.init(product: .pizza, quantity: 2), .init(product: .meat, quantity: 1)],
            [.init(product: .pizza, quantity: 2)],
            [.init(product: .pizza, quantity: 1)],
            [],
        ])
    }
    
    // MARK: Helpers
    
    private func makeSUT() -> Cart<Food> {
        return Cart<Food>()
    }
}

// MARK: - Mocks

 private enum Food: CartProduct {
    case pizza
    case meat
    
    var price: Double {
        switch self {
        case .pizza: return 8
        case .meat: return 10
        }
    }
}

private class SpyFoodChanges {
    
    private(set) var items = [[CartItem<Food>]]()
    
    func cartDidChange(_ cart: Cart<Food>) {
        items.append(cart.items)
    }
}
