//
//  CartViewModel.swift
//  
//
//  Created by Thales Frigo on 08/06/23.
//

import Foundation
import CartEngine

public final class CartViewModel: ObservableObject {
    private(set) var items = [String]()
    private(set) var totalPrice = Double(0)
}
