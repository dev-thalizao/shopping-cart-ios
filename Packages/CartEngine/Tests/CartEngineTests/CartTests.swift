import XCTest
@testable import CartEngine

open class Cart<T: CartProduct> {

    private(set) var items = [CartItem<T>]()
    
    public var totalPrice: Double {
        return items.map(\.price).reduce(0, +)
    }
    
    public var totalItems: UInt {
        return items.map(\.quantity).reduce(0, +)
    }
    
    public func add(_ product: T) {
        for (index, item) in items.enumerated() {
            if item.product == product {
                items[index] = .init(product: product, quantity: item.quantity + 1)
                return
            }
        }
        
        items.append(.init(product: product, quantity: 1))
    }
    
    public func remove(_ product: T) {
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

public protocol CartProduct: Equatable {
    var price: Double { get }
}

public struct CartItem<T: CartProduct> {
    public let product: T
    public let quantity: UInt
    
    public var price: Double {
        return product.price * Double(quantity)
    }
}

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
    
    // MARK: Helpers
    
    private func makeSUT() -> Cart<Food> {
        return Cart<Food>()
    }
}

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
