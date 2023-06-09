//
//  CartViewModel.swift
//  
//
//  Created by Thales Frigo on 08/06/23.
//

import Foundation
import CartEngine

public final class CartViewModel: ObservableObject {
    
    @Published private(set) var items = [CartItemViewModel]()
    @Published private(set) var totalPrice = Double(0)
    
    private let engine = Cart<CartProduct>()
    
    public var amountOfProducts: Int {
        return Int(engine.totalItems)
    }
    
    public var formattedTotalPrice: String {
        return NumberFormatter.br.string(from: NSNumber(value: totalPrice)) ?? ""
    }
    
    public init() {
        engine.onCartChange = { [weak self] cart in
            self?.totalPrice = cart.totalPrice
            self?.items = cart.items.map({ item in
                .init(
                    cartProduct: item.product,
                    quantity: item.quantity,
                    increase: { cart.add(item.product) },
                    decrease: { cart.remove(item.product) }
                )
            })
        }
    }
    
    public func select(_ product: Product, with size: Product.AvailableSize) {
        engine.add(.init(product: product, size: size))
    }
    
    func clear() {
        engine.clear()
    }
}
