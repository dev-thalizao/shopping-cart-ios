//
//  CartViewModel.swift
//  
//
//  Created by Thales Frigo on 08/06/23.
//

import Foundation
import CartEngine

public final class CartViewModel: ObservableObject {
    @Published private(set) var items = [String]()
    @Published private(set) var totalPrice = Double(0)
    
    typealias Item = (product: Product, size: Product.AvailableSize)
    
    func add(_ item: Item) {
        totalPrice = NumberFormatter.br.number(from: item.product.actualPrice)?.doubleValue ?? 0
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
