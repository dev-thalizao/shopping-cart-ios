//
//  ProductsMapperTests.swift
//  
//
//  Created by Thales Frigo on 06/06/23.
//

import XCTest
@testable import Marketplace

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
