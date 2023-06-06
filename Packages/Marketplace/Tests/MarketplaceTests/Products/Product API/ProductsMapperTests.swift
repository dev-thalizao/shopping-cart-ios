//
//  ProductsMapperTests.swift
//  
//
//  Created by Thales Frigo on 06/06/23.
//

import XCTest
@testable import Marketplace

final class ProductsMapper {
    
    private struct Root: Decodable {}
    
    private init() {}
    
    enum Error: Swift.Error {
        case invalidData
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Product] {
                
        guard
            response.statusCode == 200,
            let _ = try? JSONDecoder().decode(Root.self, from: data)
        else {
            throw Error.invalidData
        }
        
        return []
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
}

// MARK: - Helpers

private func emptyJSON() -> Data {
    return "{}".data(using: .utf8)!
}

private func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

private extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
