//
//  CartView.swift
//  
//
//  Created by Thales Frigo on 08/06/23.
//

import SwiftUI

public struct CartView: View {
    
    @ObservedObject private var viewModel: CartViewModel
    
    public init(viewModel: ObservedObject<CartViewModel>) {
        self._viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            ZStack {
                if viewModel.items.isEmpty {
                    Text("Seu carrinho está vazio.\nAdicione itens na aba produtos para começar.")
                        .multilineTextAlignment(.center)
                } else {
                    List {
                        ForEach(viewModel.items, id: \.sku) {
                            CartItemView(viewModel: $0)
                        }
                        HStack {
                            Text("Total").fontWeight(.light)
                            Spacer()
                            Text("\(viewModel.formattedTotalPrice)").fontWeight(.semibold)
                        }
                    }
                }
            }
            .navigationTitle("Carrinho")
            .navigationBarHidden(false)
        }
    }
}
