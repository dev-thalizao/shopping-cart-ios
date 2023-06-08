//
//  File.swift
//  
//
//  Created by Thales Frigo on 08/06/23.
//

import Foundation
import CartEngine

struct CartProduct: Equatable, CartEngine.CartProduct {
    
    let product: Product
    let size: Product.AvailableSize
    
    var price: Double {
        return NumberFormatter.br.number(from: product.actualPrice)?.doubleValue ?? 0
    }
}
