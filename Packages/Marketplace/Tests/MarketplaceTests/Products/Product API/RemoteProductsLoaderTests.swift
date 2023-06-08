//
//  RemoteProductsLoaderTests.swift
//  
//
//  Created by Thales Frigo on 08/06/23.
//

import XCTest
import NetworkEngine
@testable import Marketplace

final class RemoteProductsLoaderTests: XCTestCase {

    func test_loadProducts_returnProductsWithValidResponse() async throws {
        let (sut, spy) = makeSUT()
        spy.stubRequest(with: (makeProductsJSON(), HTTPURLResponse.OK))
        
        let products = try await sut.load()
        
        XCTAssertEqual(products, [makeDressProduct(), makeBraceletProduct()])
        XCTAssertEqual(spy.requests, [anyURLRequest()])
    }
    
    func test_loadProducts_throwsErrorWithInvalidResponse() async throws {
        let (sut, spy) = makeSUT()
        spy.stubRequest(with: AnyError())
        
        let expectation = expectation(description: "expect call to throw error")
        
        do {
            _ = try await sut.load()
        } catch {
            XCTAssertEqual(spy.requests, [anyURLRequest()])
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (RemoteProductsLoader, HTTPClientSpy) {
        let spy = HTTPClientSpy()
        let sut = RemoteProductsLoader(httpClient: spy, resourceURL: anyURL())
        trackForMemoryLeaks(spy, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, spy)
    }
}

// MARK: - Mocks

private final class HTTPClientSpy: HTTPClient {
    
    typealias Stub = (URLRequest) -> Result<(Data, HTTPURLResponse), Error>
    
    private(set) var requests = [URLRequest]()
    private(set) var stub: Stub?
    
    func execute(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        requests.append(request)
        return try await withCheckedThrowingContinuation({ [stub] continuation in
            continuation.resume(with: stub!(request))
        })
    }
    
    func stubRequest(with error: Error) {
        stub = { _ in .failure(error) }
    }
    
    func stubRequest(with result: (Data, HTTPURLResponse)) {
        stub = { _ in .success(result) }
    }
}
