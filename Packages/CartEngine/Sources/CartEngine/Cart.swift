//
//  Cart.swift
//
//
//  Created by Thales Frigo on 04/06/23.
//

import Foundation

public typealias OnCartChange<T: CartProduct> = (Cart<T>) -> Void

open class Cart<T: CartProduct> {

    public var totalPrice: Double {
        return items.map(\.price).reduce(0, +)
    }
    
    public var totalItems: UInt {
        return items.map(\.quantity).reduce(0, +)
    }
    
    public var onCartChange: OnCartChange<T>?
    
    public private(set) var items = [CartItem<T>]()
    
    public init() {}
    
    public func add(_ product: T) {
        for (index, item) in items.enumerated() {
            if item.product == product {
                items[index] = .init(product: product, quantity: item.quantity + 1)
                onCartChange?(self)
                return
            }
        }
        
        items.append(.init(product: product, quantity: 1))
        onCartChange?(self)
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
                onCartChange?(self)
                return
            }
        }
    }
}

public struct CartItem<T: CartProduct>: Equatable {
    public let product: T
    public let quantity: UInt
    
    public var price: Double {
        return product.price * Double(quantity)
    }
}
