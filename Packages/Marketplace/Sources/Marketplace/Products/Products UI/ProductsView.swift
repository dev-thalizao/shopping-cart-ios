//
//  ProductsView.swift
//  
//
//  Created by Thales Frigo on 06/06/23.
//

import SwiftUI

struct ProductsView: View {
    
    var columns: [GridItem] = [
        GridItem(.flexible()),
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                
                ForEach((0..<10)) { _ in
                    ProductView()
                }
            }
            .padding(16)
        }.background(Color.gray.opacity(0.1))
        
    }
}

struct ProductView: View {
    
    let product = Product(
        name: "VESTIDO TRANSPASSE BOW",
        image: URL(string: "https://d3l7rqep7l31az.cloudfront.net/images/products/20002605_615_catalog_1.jpg?1460136912")!,
        onSale: false,
        regularPrice: "R$ 199,90",
        actualPrice: "R$ 199,90",
        discountPercentage: "25%",
        installments: "3x R$ 66,63",
        sizes: [
            Product.Size(available: false, size: "PP", sku: "5807_343_0_PP"),
            Product.Size(available: true, size: "P", sku: "5807_343_0_P"),
            Product.Size(available: true, size: "M", sku: "5807_343_0_M"),
            Product.Size(available: true, size: "G", sku: "5807_343_0_G"),
            Product.Size(available: false, size: "GG", sku: "5807_343_0_GG"),
        ]
    )
    
    var body: some View {
        VStack() {
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: product.image, transaction: Transaction(animation: .easeInOut(duration: 0.35))) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                 
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                 
                    case .failure(_):
                        Image(systemName: "exclamationmark.icloud")
                            .resizable()
                            .scaledToFit()
                 
                    @unknown default:
                        ProgressView()
                    }
                }.frame(width: 300, height: 500)
                
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
                    ForEach(product.availableSizes, id: \.self) { size in
                        Circle()
                            .stroke(.black)
                            .frame(width: 40, height: 40)
                            .overlay {
                            Text(size)
                        }
                            
                    }
                }
            }.padding()
        }
        .background(.white)
        .cornerRadius(12)
    }
}

extension Product {
    var availableSizes: [String] {
        return sizes.filter({ $0.available }).map(\.size)
    }
}

#if DEBUG

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView()
    }
}

#endif
