//
//  CartItemView.swift
//  
//
//  Created by Thales Frigo on 08/06/23.
//

import SwiftUI

struct CartItemView: View {

    private let viewModel: CartItemViewModel
    
    init(viewModel: CartItemViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            ProductImageView(
                url: viewModel.cartProduct.product.image
            ).frame(width: 40, height: 60)
            VStack(alignment: .leading, spacing: 2.0) {
                Text(viewModel.cartProduct.product.name)
                    .font(.subheadline)
                
                Text("Tamanho: \(viewModel.cartProduct.size.size)")
                    .font(.caption2)
                
                Text("SKU: \(viewModel.sku)")
                    .font(.caption2)
                
                Text("Preço: \(viewModel.formattedPrice)")
                    .font(.caption2)
                    .fontWeight(.semibold)
            }
            Spacer()
            HStack {
                Button(
                    action: viewModel.increase,
                    label: {
                        Image(systemName: "plus")
                            .frame(width: 30, height: 30)
                            .contentShape(Rectangle())
                    }
                )
                .buttonStyle(PlainButtonStyle())
                
                Text("\(viewModel.quantity)")
                    .fontWeight(.light)
                
                Button(
                    action: viewModel.decrease,
                    label: {
                        Image(systemName: "minus")
                            .frame(width: 30, height: 30)
                            .contentShape(Rectangle())
                    }
                )
                .buttonStyle(PlainButtonStyle())
            }
        }
        
    }
}

struct CartItemView_Previews: PreviewProvider {
    static var previews: some View {
        CartItemView(
            viewModel: .init(
                cartProduct: .init(
                    product: Product(
                        name: "VESTIDO TRANSPASSE BOW",
                        image: URL(string: "https://d3l7rqep7l31az.cloudfront.net/images/products/20002605_615_catalog_1.jpg?1460136912")!,
                        onSale: false,
                        regularPrice: "R$ 199,90",
                        actualPrice: "R$ 199,90",
                        discountPercentage: "",
                        installments: "3x R$ 66,63",
                        sizes: [
                            Product.Size(available: false, size: "PP", sku: "5807_343_0_PP"),
                            Product.Size(available: true, size: "P", sku: "5807_343_0_P"),
                            Product.Size(available: true, size: "M", sku: "5807_343_0_M"),
                            Product.Size(available: true, size: "G", sku: "5807_343_0_G"),
                            Product.Size(available: false, size: "GG", sku: "5807_343_0_GG"),
                        ]
                    ),
                    size: .init(size: "GG", sku: "sku")
                ),
                quantity: 2,
                increase: {},
                decrease: {}
            )
        )
    }
}
