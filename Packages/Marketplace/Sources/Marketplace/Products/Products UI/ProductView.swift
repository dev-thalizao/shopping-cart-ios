//
//  ProductView.swift
//  
//
//  Created by Thales Frigo on 08/06/23.
//

import SwiftUI

struct ProductView: View {
    
    private let product: Product
    private let onSizeSelected: (Product, Product.AvailableSize) -> Void
    
    internal init(product: Product, onSizeSelected: @escaping (Product, Product.AvailableSize) -> Void) {
        self.product = product
        self.onSizeSelected = onSizeSelected
    }
    
    var body: some View {
        VStack() {
            ZStack(alignment: .bottomTrailing) {
                ProductImageView(url: product.image).frame(height: 300)
                
                if product.onSale {
                    Text("(\(product.discountPercentage) OFF)")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(8.0)
                        .multilineTextAlignment(.center)
                        .background(RoundedRectangle(cornerRadius: 8).fill(.black))
                }
            }
            Divider()
            VStack {
                Text(product.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                HStack {
                    Text(product.actualPrice)
                    Text(product.installments)
                        .foregroundColor(.gray)
                }
                HStack {
                    Text(product.regularPrice)
                        .foregroundColor(.gray)
                        .strikethrough(true, color: .gray)
                    Text("(\(product.discountPercentage) OFF)")
                        .foregroundColor(.red)
                        .fontWeight(.semibold)
                }.opacity(product.onSale ? 1 : 0)
                HStack {
                    ForEach(product.availableSizes, id: \.sku) { size in
                        SizeView(size: size) { size in
                            onSizeSelected(product, size)
                        }
                    }
                }
            }.padding()
        }
        .background(.white)
        .cornerRadius(12)
    }
}
