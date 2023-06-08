//
//  ProductsView.swift
//  
//
//  Created by Thales Frigo on 06/06/23.
//

import SwiftUI

public struct ProductsView: View {
    
    @ObservedObject private var viewModel: ProductsViewModel
    private let onSelection: (Product) -> ProductDetailView
    private let onSizeSelected: (Product, Product.Size) -> Void
    
    var columns: [GridItem] = [
        GridItem(.flexible()),
    ]
    
    public init(
        viewModel: ObservedObject<ProductsViewModel>,
        onSelection: @escaping (Product) -> ProductDetailView,
        onSizeSelected: @escaping (Product, Product.Size) -> Void
    ) {
        self._viewModel = viewModel
        self.onSelection = onSelection
        self.onSizeSelected = onSizeSelected
    }
    
    public var body: some View {
        NavigationView {
            ZStack {
                switch viewModel.state {
                case .initial:
                    Color.gray.opacity(0.1).task { await viewModel.loadProducts() }
                case .failure:
                    Text("Houve um erro, tente novamente mais tarde.")
                case .loading:
                    ProgressView()
                case let .success(products):
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(products, id: \.name) { product in
//                                NavigationLink(destination: onSelection(product)) {
//                                    ProductView(product: product)
//                                }
                                ProductView(product: product, onSizeSelected: onSizeSelected)
                            }
                        }
                        .padding(16)

                    }
                }
            }
            .background(Color.gray.opacity(0.1))
            .navigationTitle("Produtos")
            .navigationBarHidden(false)
            .toolbar {
                if viewModel.canFilter {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        //Image(systemName: "checkmark.seal")
                        switch viewModel.filter {
                        case .all:
                            Button("Ver promoções") {
                                viewModel.applyFilter(.onSale)
                            }
                        case .onSale:
                            Button("Ver todos") {
                                viewModel.applyFilter(.all)
                            }
                        }
                    }
                }
                
            }
        }.task { await viewModel.loadProducts() }
    }
}

struct ProductView: View {
    
    private let product: Product
    private let onSizeSelected: (Product, Product.Size) -> Void
    
    internal init(product: Product, onSizeSelected: @escaping (Product, Product.Size) -> Void) {
        self.product = product
        self.onSizeSelected = onSizeSelected
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

#if DEBUG

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView(
            viewModel: .init(initialValue: .init(loader: StubProductsLoader())),
            onSelection: { ProductDetailView(product: $0) }, onSizeSelected: { _, _ in}
        )
    }
}

class StubProductsLoader: ProductsLoader {
    func load() async throws -> [Product] {
        return [
            Product(
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
            Product(
                name: "VESTIDO TRANSPASSE BOW PROMO",
                image: URL(string: "https://d3l7rqep7l31az.cloudfront.net/images/products/20002605_615_catalog_1.jpg?1460136912")!,
                onSale: true,
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
            )
        ]
    }
}

#endif
