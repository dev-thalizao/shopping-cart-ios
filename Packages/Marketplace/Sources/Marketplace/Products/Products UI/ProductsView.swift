//
//  ProductsView.swift
//  
//
//  Created by Thales Frigo on 06/06/23.
//

import SwiftUI

public struct ProductsView: View {
    
    @ObservedObject private var viewModel: ProductsViewModel
    
    var columns: [GridItem] = [
        GridItem(.flexible()),
    ]
    
    public init(viewModel: ObservedObject<ProductsViewModel>) {
        self._viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.products, id: \.name) { product in
                        ProductView(product: product)
                    }
                }
                .padding(16)
            }.background(Color.gray.opacity(0.1))
                .navigationTitle("Produtos")
                .navigationBarHidden(false)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        //Image(systemName: "checkmark.seal")
                        Button("Ver promoções") {}
                    }
                }
        }.task {
            try? await viewModel.loadProducts()
        }
    }
}

struct ProductView: View {
    
    private let product: Product
    
    internal init(product: Product) {
        self.product = product
    }
    
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
                            .scaledToFit()
                 
                    case .failure(_):
                        Image(systemName: "exclamationmark.icloud")
                            .resizable()
                            .scaledToFit()
                 
                    @unknown default:
                        ProgressView()
                    }
                }.frame(height: 300)
                
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

//struct ProductsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductsView()
//    }
//}

#endif
