//
//  TestObserver.swift
//  
//
//  Created by Thales Frigo on 07/06/23.
//

import Foundation
import Combine

final class TestObserver<T: Equatable> {
    
    private(set) var values = [T]()
    
    private var cancellables = [AnyCancellable]()
    
    init(_ publisher: Published<T>.Publisher) {
        publisher
            .dropFirst()
            .sink(receiveValue: { [weak self] in
                self?.values.append($0)
            })
            .store(in: &cancellables)
    }
}
