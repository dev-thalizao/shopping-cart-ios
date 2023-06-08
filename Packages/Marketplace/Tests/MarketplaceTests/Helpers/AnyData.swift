//
//  AnyData.swift
//  
//
//  Created by Thales Frigo on 08/06/23.
//

import Foundation
@testable import Marketplace

func makeCartItemViewModel(
    product: CartProduct = .init(product: makeDressProduct(), size: makeGAvailableSize()),
    quantity: UInt = 1
) -> CartItemViewModel {
    return CartItemViewModel(
        cartProduct: .init(product: makeDressProduct(), size: makeGAvailableSize()),
        quantity: quantity,
        increase: {},
        decrease: {}
    )
}

func makeGAvailableSize() -> Product.AvailableSize {
    return Product.AvailableSize(size: "G", sku: "5807_343_0_G")
}

func makeDressProduct(onSale: Bool = false) -> Product {
    return Product(
        name: "VESTIDO TRANSPASSE BOW",
        image: URL(string: "https://d3l7rqep7l31az.cloudfront.net/images/products/20002605_615_catalog_1.jpg?1460136912")!,
        onSale: onSale,
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

func makeBraceletProduct() -> Product {
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

func emptyJSON() -> Data {
    let json = """
    { "products": [] }
    """
    return Data(json.utf8)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyURLRequest() -> URLRequest {
    return URLRequest(url: anyURL())
}

func makeProductsJSON() -> Data {
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

struct AnyError: Error {}
