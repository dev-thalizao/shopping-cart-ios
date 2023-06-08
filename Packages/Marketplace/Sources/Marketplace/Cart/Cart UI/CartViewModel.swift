//
//  CartViewModel.swift
//  
//
//  Created by Thales Frigo on 08/06/23.
//

import Foundation
import CartEngine

struct ProductWithSize: Equatable, CartProduct {
    
    let product: Product
    let size: Product.AvailableSize
    
    var price: Double {
        return NumberFormatter.br.number(from: product.actualPrice)?.doubleValue ?? 0
    }
}

struct CartItemViewModel: Equatable {
    
    let product: ProductWithSize
    let quantity: UInt
    let increase: () -> Void
    let decrease: () -> Void
    
    var price: Double {
        product.price * Double(quantity)
    }
    
    var formattedPrice: String {
        return NumberFormatter.br.string(from: NSNumber(value: price)) ?? ""
    }
    
    static func == (lhs: CartItemViewModel, rhs: CartItemViewModel) -> Bool {
        return lhs.product == rhs.product && lhs.quantity == rhs.quantity
    }
}

public final class CartViewModel: ObservableObject {
    
    @Published private(set) var items = [CartItemViewModel]()
    @Published private(set) var totalPrice = Double(0)
    
    private let engine = Cart<ProductWithSize>()
    
    public init() {
        engine.onCartChange = { [weak self] cart in
            self?.totalPrice = cart.totalPrice
            self?.items = cart.items.map({ item in
                .init(
                    product: item.product,
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
}

extension NumberFormatter {
    
    static var br: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "BRL"
        formatter.positivePrefix = "R$ "
        return formatter
    }
}
