//
//  NumberFormatter+BR.swift
//  
//
//  Created by Thales Frigo on 08/06/23.
//

import Foundation

extension NumberFormatter {
    
    static var br: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "BRL"
        formatter.positivePrefix = "R$ "
        formatter.maximumFractionDigits = 2
        return formatter
    }
}
