//
//  SizeView.swift
//  
//
//  Created by Thales Frigo on 07/06/23.
//

import SwiftUI

struct SizeView: View {
    
    private let size: Product.AvailableSize
    private let onSelection: (Product.AvailableSize) -> Void
    
    init(size: Product.AvailableSize, onSelection: @escaping (Product.AvailableSize) -> Void) {
        self.size = size
        self.onSelection = onSelection
    }
    
    var body: some View {
        Button(action: {
            onSelection(size)
        }) {
            Text(size.size)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Color.white)
                        .shadow(color: .gray, radius: 2, x: 0, y: 2)
                ).padding(.bottom, 8)
                
        }
    }
}

#if DEBUG

struct SizeView_Previews: PreviewProvider {
    static var previews: some View {
        SizeView(size: .init(size: "GG", sku: "gg"), onSelection: { print($0) })
    }
}

#endif
