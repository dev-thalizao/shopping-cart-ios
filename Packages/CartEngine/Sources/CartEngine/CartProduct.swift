//
//  CartProduct.swift
//  
//
//  Created by Thales Frigo on 06/06/23.
//

import Foundation

/// It's the requirement that a product need to have to be used in a cart
public protocol CartProduct: Equatable {
    
    /// The price of a product that will be calculated in a cart
    var price: Double { get }
}
