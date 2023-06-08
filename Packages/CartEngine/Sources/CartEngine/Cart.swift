//
//  Cart.swift
//
//
//  Created by Thales Frigo on 04/06/23.
//

import Foundation

/// A class that holds all the cart logic
open class Cart<T: CartProduct> {

    /// The total price of the whole cart
    public var totalPrice: Double {
        return items.map(\.price).reduce(0, +)
    }
    
    /// The count of all items regarding the quantity
    public var totalItems: UInt {
        return items.map(\.quantity).reduce(0, +)
    }
    
    /// The closure that communicate the changes
    public var onCartChange: ((Cart<T>) -> Void)?
    
    /// The list of all items added to the cart
    public private(set) var items = [CartItem<T>]()
    
    /// Public init
    public init() {}
    
    /**
     * Adds a product to the cart
     * If the product already exists, increment the quantity.
     *
     * - parameter product: The product to add.
     */
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
    
    /**
     * Removes a product from the cart
     * If the product has quantity greater than one, decrease the quantity. Otherwise, the product is removed from the cart.
     *
     * - parameter product: The product to remove.
     */
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
    
    /**
     * Removes all the products from the cart
     */
    public func clear() {
        items.removeAll()
        onCartChange?(self)
    }
}
