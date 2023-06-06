//
//  ProductsMapperTests.swift
//  
//
//  Created by Thales Frigo on 06/06/23.
//

import XCTest
@testable import Marketplace

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

final class ProductsMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = emptyJSON()
        let samples = [199, 201, 300, 400, 500]
        
        try samples.map(HTTPURLResponse.init).forEach { response in
            XCTAssertThrowsError(
                try ProductsMapper.map(json, from: response)
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() throws {
        let invalidJSON = Data("invalid json".utf8)
        let response = HTTPURLResponse(statusCode: 200)
        XCTAssertThrowsError(
            try ProductsMapper.map(invalidJSON, from: response)
        )
    }
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSON() throws {
        let emptyJSON = emptyJSON()
        let response = HTTPURLResponse(statusCode: 200)
        XCTAssertEqual(try ProductsMapper.map(emptyJSON, from: response), [])
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithProductsJSON() throws {
        let productsJSON = makeProductsJSON()
        let response = HTTPURLResponse(statusCode: 200)
        
        let expectedProducts = [
            makeDressProduct(),
            makeBraceletProduct()
        ]
        
        XCTAssertEqual(try ProductsMapper.map(productsJSON, from: response), expectedProducts)
    }
}

// MARK: - Helpers

private func emptyJSON() -> Data {
    let json = """
    { "products": [] }
    """
    return Data(json.utf8)
}

private func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

private extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

private func makeDressProduct() -> Product {
    return Product(
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
    )
}

private func makeBraceletProduct() -> Product {
    return Product(
        name: "PULSEIRA STYLISH",
        image: URL(string: "https://d3l7rqep7l31az.cloudfront.net/images/products/20001913_009_catalog_1.jpg?")!,
        onSale: false,
        regularPrice: "R$ 29,90",
        actualPrice: "R$ 29,90",
        discountPercentage: "",
        installments: "1x R$ 29,90",
        sizes: [
            Product.Size(available: true, size: "U", sku: "4279_1000018_0_U")
        ]
    )
}

private func makeProductsJSON() -> Data {
    return """
    {
      "products": [
        {
          "name": "VESTIDO TRANSPASSE BOW",
          "style": "20002605",
          "code_color": "20002605_613",
          "color_slug": "tapecaria",
          "color": "TAPEÇARIA",
          "on_sale": false,
          "regular_price": "R$ 199,90",
          "actual_price": "R$ 199,90",
          "discount_percentage": "",
          "installments": "3x R$ 66,63",
          "image": "https://d3l7rqep7l31az.cloudfront.net/images/products/20002605_615_catalog_1.jpg?1460136912",
          "sizes": [
            {
              "available": false,
              "size": "PP",
              "sku": "5807_343_0_PP"
            },
            {
              "available": true,
              "size": "P",
              "sku": "5807_343_0_P"
            },
            {
              "available": true,
              "size": "M",
              "sku": "5807_343_0_M"
            },
            {
              "available": true,
              "size": "G",
              "sku": "5807_343_0_G"
            },
            {
              "available": false,
              "size": "GG",
              "sku": "5807_343_0_GG"
            }
          ]
        },
        {
          "name": "PULSEIRA STYLISH",
          "style": "20001913",
          "code_color": "20001913_009",
          "color_slug": "dourado",
          "color": "dourado",
          "on_sale": false,
          "regular_price": "R$ 29,90",
          "actual_price": "R$ 29,90",
          "discount_percentage": "",
          "installments": "1x R$ 29,90",
          "image": "https://d3l7rqep7l31az.cloudfront.net/images/products/20001913_009_catalog_1.jpg?",
          "sizes": [
            {
              "available": true,
              "size": "U",
              "sku": "4279_1000018_0_U"
            }
          ]
        }
      ]
    }
    """.data(using: .utf8)!
}
