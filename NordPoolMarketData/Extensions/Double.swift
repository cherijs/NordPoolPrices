//
//  Double.swift
//  NordPoolMarketData
//
//  Created by Arturs Cirsis on 25/09/2022.
//

import Foundation
extension Double {
    func formatAsCurrency() -> String {
        let formatter = NumberFormatter()

        formatter.locale = Locale(identifier: "lv-LV")
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? "N/A"
    }
}


