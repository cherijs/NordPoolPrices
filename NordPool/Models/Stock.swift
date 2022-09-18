//
//  Stock.swift
//  NordPool
//
//  Created by Arturs Cirsis on 16/09/2022.
//

import Foundation

struct Stock: Decodable {
    let symbol: String
    let description: String
    let price: Double
}

