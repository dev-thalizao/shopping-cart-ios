//
//  HTTPURLResponse+StatusCode.swift
//  
//
//  Created by Thales Frigo on 08/06/23.
//

import Foundation

extension HTTPURLResponse {
    
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
    
    static var OK: HTTPURLResponse {
        .init(statusCode: 200)
    }
}
