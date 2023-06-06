//
//  ProductsMapper.swift
//  
//
//  Created by Thales Frigo on 06/06/23.
//

import Foundation

final class ProductsMapper {
    
    private init() {}
    
    enum Error: Swift.Error {
        case invalidData
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Product] {
                
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard
            response.statusCode == 200,
            let root = try? decoder.decode(Root.self, from: data)
        else {
            throw Error.invalidData
        }
        
        return root.products.map { remoteProduct in
            return Product(
                name: remoteProduct.name,
                image: remoteProduct.image,
                onSale: remoteProduct.onSale,
                regularPrice: remoteProduct.regularPrice,
                actualPrice: remoteProduct.actualPrice,
                discountPercentage: remoteProduct.discountPercentage,
                installments: remoteProduct.installments,
                sizes: remoteProduct.sizes.map { remoteSize in
                    return Product.Size(available: remoteSize.available, size: remoteSize.size, sku: remoteSize.sku)
                }
            )
        }
    }
}

extension ProductsMapper {

    private struct Root: Decodable {
        let products: [RemoteProduct]
    }

    private struct RemoteProduct: Decodable {
        let name: String
        let image: URL
        let onSale: Bool
        let regularPrice: String
        let actualPrice: String
        let discountPercentage: String
        let installments: String
        let sizes: [RemoteProductSize]
    }

    private struct RemoteProductSize: Decodable {
        let available: Bool
        let size: String
        let sku: String
    }
}
