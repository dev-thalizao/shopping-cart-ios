//
//  CartItemViewModel.swift
//  
//
//  Created by Thales Frigo on 08/06/23.
//

import Foundation

struct CartItemViewModel {
    
    let cartProduct: CartProduct
    let quantity: UInt
    let increase: () -> Void
    let decrease: () -> Void
    
    var sku: String {
        cartProduct.size.sku
    }
    
    var price: Double {
        cartProduct.price * Double(quantity)
    }
    
    var formattedPrice: String {
        return NumberFormatter.br.string(from: NSNumber(value: price)) ?? ""
    }
}

extension CartItemViewModel: Equatable {
    
    static func == (lhs: CartItemViewModel, rhs: CartItemViewModel) -> Bool {
        return lhs.cartProduct == rhs.cartProduct && lhs.quantity == rhs.quantity
    }
}
