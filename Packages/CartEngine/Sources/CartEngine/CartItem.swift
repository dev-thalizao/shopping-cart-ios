//
//  CartItem.swift
//  
//
//  Created by Thales Frigo on 06/06/23.
//

import Foundation

/// Basic struct that holds the product and the quantity
public struct CartItem<T: CartProduct>: Equatable {
    
    /// The product added to a cart
    public let product: T
    /// The current quantity of a product in the cart
    public let quantity: UInt
    
    /// The price of a product multiplied by quantity that will be summed in a cart
    public var price: Double {
        return product.price * Double(quantity)
    }
}
