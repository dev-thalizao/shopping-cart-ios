//
//  Product.swift
//  
//
//  Created by Thales Frigo on 06/06/23.
//

import Foundation

public struct Product: Equatable {
    let name: String
    let image: URL
    let onSale: Bool
    let regularPrice: String
    let actualPrice: String
    let discountPercentage: String
    let installments: String
    let sizes: [Product.Size]
    
    public var availableSizes: [Size] {
        return sizes.filter({ $0.available })
    }
}

extension Product {
    
    public struct Size: Equatable {
        let available: Bool
        let size: String
        let sku: String
    }
}
