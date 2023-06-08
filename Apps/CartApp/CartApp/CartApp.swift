//
//  CartApp.swift
//  CartApp
//
//  Created by Thales Frigo on 04/06/23.
//

import SwiftUI
import Marketplace
import NetworkEngine

@main
struct CartApp: App {
    
    @ObservedObject var productsViewModel = ProductsViewModel(
        loader: RemoteProductsLoader(
            httpClient: URLSessionHTTPClient(session: .shared),
            resourceURL: Environment.productsURL
        )
    )
    
    @ObservedObject var cartViewModel = CartViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ProductsView(
                    viewModel: self._productsViewModel,
                    onSelection: { [cartViewModel] product, size in
                        cartViewModel.select(product, with: size)
                    })
                    .tabItem { Label("Produtos", systemImage: "bag.badge.plus") }
                    
                CartView(viewModel: self._cartViewModel)
                    .tabItem { Label("Carrinho", systemImage: "cart") }
                    .badge(cartViewModel.amountOfProducts)
            }
        }
    }
}

