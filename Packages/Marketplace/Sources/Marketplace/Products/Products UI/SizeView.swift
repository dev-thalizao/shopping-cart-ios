//
//  SizeView.swift
//  
//
//  Created by Thales Frigo on 07/06/23.
//

import SwiftUI

struct SizeView: View {
    
    private let size: Product.Size
    private let onSelection: (Product.Size) -> Void
    
    init(size: Product.Size, onSelection: @escaping (Product.Size) -> Void) {
        self.size = size
        self.onSelection = onSelection
    }
    
    var body: some View {
        Button(action: {
            onSelection(size)
        }) {
            Text(size.size)
                .font(.system(size: 17))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding()
                .background(
                    Circle()
                        .fill(Color.white)
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
            )
        }
    }
}

struct SizeView_Previews: PreviewProvider {
    static var previews: some View {
        SizeView(size: .init(available: true, size: "GG", sku: "gg"), onSelection: { print($0) })
    }
}
