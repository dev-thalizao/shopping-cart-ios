import XCTest
@testable import CartEngine

open class Cart {
    public private(set) var items = [Any]()
}

final class CartTests: XCTestCase {
    
    func test_init_startsWithNoItems() {
        XCTAssertTrue(Cart().items.isEmpty)
    }
}
