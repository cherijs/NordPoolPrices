//
//  ApiResponse.swift
//  NordPool
//
//  Created by Arturs Cirsis on 16/09/2022.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nordPoolResponse = try? newJSONDecoder().decode(NordPoolResponse.self, from: jsonData)

import Foundation

// MARK: - NordPoolResponse
struct NordPoolResponse: Codable {
    let data: DataClass
    let currency: String?
}

// MARK: - DataClass
struct DataClass: Codable {
    let rows: [Row]
    let dataEnddate: String
    let units: [String]
    let dateUpdated: String

    enum CodingKeys: String, CodingKey {
        case rows = "Rows"
        case dataEnddate = "DataEnddate"
        case units = "Units"
        case dateUpdated = "DateUpdated"
    }
}

// MARK: - Row
struct Row: Codable {
    let columns: [Column]
    let name, startTime, endTime: String

    enum CodingKeys: String, CodingKey {
        case columns = "Columns"
        case name = "Name"
        case startTime = "StartTime"
        case endTime = "EndTime"
    }
}

// MARK: - Column
struct Column: Codable {
    let index, scale: Int
    let isValid: Bool
    let name, value, displayNameOrDominatingDirection: String
    let isOfficial: Bool

    enum CodingKeys: String, CodingKey {
        case index = "Index"
        case scale = "Scale"
        case isValid = "IsValid"
        case name = "Name"
        case value = "Value"
        case displayNameOrDominatingDirection = "DisplayNameOrDominatingDirection"
        case isOfficial = "IsOfficial"
    }
}


//{
//  "data": {
//    "Rows": [
//      {
//        "Columns": [
//          {
//            "Index": 0,
//            "Scale": 0,
//            "IsValid": false,
//            "Name": "16-09-2022",
//            "Value": "333,52",
//            "DisplayNameOrDominatingDirection": "333,52",
//            "IsOfficial": true
//          }
//        ],
//        "Name": "00&nbsp;-&nbsp;01",
//        "StartTime": "2022-09-16T00:00:00",
//        "EndTime": "2022-09-16T01:00:00"
//      }
//    ],
//    "DataEnddate": "2022-09-17T00:00:00",
//    "Units": [
//      "EUR/MWh"
//    ],
//    "DateUpdated": "2022-09-15T12:45:28.368"
//  },
//  "currency": "EUR"
//}
