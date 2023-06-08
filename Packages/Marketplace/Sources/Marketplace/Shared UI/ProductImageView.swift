//
//  ProductImageView.swift
//  
//
//  Created by Thales Frigo on 08/06/23.
//

import SwiftUI

struct ProductImageView: View {
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    var body: some View {
        AsyncImage(url: url, transaction: Transaction(animation: .easeInOut(duration: 0.35))) { phase in
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
        }
    }
}

#if DEBUG

struct ProductImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProductImageView(url: URL(string: "https://d3l7rqep7l31az.cloudfront.net/images/products/20002605_615_catalog_1.jpg?1460136912")!)
    }
}

#endif
