//
//  URLSessionHTTPClientTests.swift
//  
//
//  Created by Thales Frigo on 08/06/23.
//

import XCTest
@testable import NetworkEngine

final class URLSessionHTTPClientTests: XCTestCase {
    
    private var httpClient: HTTPClient!
    
    override func setUpWithError() throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        
        URLProtocol.registerClass(MockURLProtocol.self)
        
        httpClient = URLSessionHTTPClient(
            session: .init(configuration: config)
        )
    }
    
    override func tearDownWithError() throws {
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }
    
    func test_execute_returnResponseAndData_withSuccefullyRequest() async throws {
        struct NotMockedURL: Error {}
        
        let validData = Data("valid".utf8)
        
        MockURLProtocol.mock = { url in
            guard url == anyURL() else {
                throw NotMockedURL()
            }
            
            return validData
        }
        
        let (data, response) = try await httpClient.execute(anyRequest())
        
        XCTAssertEqual(data, validData)
        XCTAssertEqual(response.statusCode, 200)
    }
    
    func test_execute_throwsError_withFailedRequest() async throws {
        struct AnyError: Error {}
        
        let expectation = expectation(description: "expect call to throw error")
        
        MockURLProtocol.mock = { _ in throw AnyError() }
        
        do {
            _ = try await httpClient.execute(anyRequest())
        } catch {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}

private func anyURL() -> URL! {
    return URL(string: "https://any-url.com")
}

private func anyRequest() -> URLRequest {
    return URLRequest(url: anyURL())
}

final class MockURLProtocol: URLProtocol {
    
    struct EmptyData: Error {}
    
    static var mock: (URL) throws -> Data = { _ in throw EmptyData() }
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        guard let client = client else { return }
        
        do {
            let url = try XCTUnwrap(request.url)
            
            let data = try MockURLProtocol.mock(url)
            
            let response = try XCTUnwrap(HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: "HTTP/1.1",
                headerFields: nil
            ))
            
            client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client.urlProtocol(self, didLoad: data)
        } catch {
            client.urlProtocol(self, didFailWithError: error)
        }
        
        client.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
