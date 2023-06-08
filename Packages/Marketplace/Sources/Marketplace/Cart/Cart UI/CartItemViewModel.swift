//
//  CartItemViewModel.swift
//  
//
//  Created by Thales Frigo on 08/06/23.
//

import Foundation

struct CartItemViewModel {
    
    let product: CartProduct
    let quantity: UInt
    let increase: () -> Void
    let decrease: () -> Void
    
    var price: Double {
        product.price * Double(quantity)
    }
    
    var formattedPrice: String {
        return NumberFormatter.br.string(from: NSNumber(value: price)) ?? ""
    }
}

extension CartItemViewModel: Equatable {
    
    static func == (lhs: CartItemViewModel, rhs: CartItemViewModel) -> Bool {
        return lhs.product == rhs.product && lhs.quantity == rhs.quantity
    }
}
