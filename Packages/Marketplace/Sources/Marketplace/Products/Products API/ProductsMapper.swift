//
//  ProductsMapper.swift
//  
//
//  Created by Thales Frigo on 06/06/23.
//

import Foundation

public final class ProductsMapper {
    
    private init() {}
    
    enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Product] {
                
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard
            response.statusCode == 200,
            let root = try? decoder.decode(Root.self, from: data)
        else {
            throw Error.invalidData
        }
        
        return root.products.compactMap { remoteProduct in
            return Product(
                name: remoteProduct.name,
                image: URL(string: remoteProduct.image) ?? .fallback(),
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
        let image: String
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

private extension URL {
    
    // Just a valid url without existing host
    static func fallback() -> URL {
        return URL(string: "https://any-url.com")!
    }
}
