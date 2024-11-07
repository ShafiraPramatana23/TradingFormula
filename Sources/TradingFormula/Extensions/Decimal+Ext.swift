//
//  File.swift
//  
//
//  Created by Shafira on 11/10/24.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        NSDecimalNumber(decimal: self).doubleValue
    }

    var intValue: Int {
        NSDecimalNumber(decimal: self).intValue
    }
}
