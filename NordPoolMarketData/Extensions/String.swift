//
//  String.swift
//  NordPoolMarketData
//
//  Created by Arturs Cirsis on 25/09/2022.
//

import Foundation
extension String {
    var withoutHtmlTags: String {
        return self.replacingOccurrences(of: "&[^;]+;", with: "", options: String.CompareOptions.regularExpression, range: nil)
    }
    
    func toDouble() -> Double? {
        let Formatter: NumberFormatter = NumberFormatter()
        Formatter.locale =  Locale(identifier: "lv-LV")
        return Formatter.number(from: self)?.doubleValue
    }
    func toFloat() -> Float? {
        let Formatter: NumberFormatter = NumberFormatter()
        Formatter.locale =  Locale(identifier: "lv-LV")
        return Formatter.number(from: self)?.floatValue
    }
    
    func toDate(dateFormat:String = "yyyy-MM-dd'T'HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(identifier: "CET")
        return dateFormatter.date(from: self)
    }
    func originToString(dateFormat: String) -> String {
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        
        // Set Date Format
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(identifier: "CET")
        // Convert String to Date
        let date = (dateFormatter.date(from: self)?.getFormattedDate(format: "d MMM EEEE"))
        return date?.capitalized ?? self
    }
}
