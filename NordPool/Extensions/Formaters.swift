//
//  Formaters.swift
//  NordPool
//
//  Created by Arturs Cirsis on 16/09/2022.
//

import Foundation

extension Double {
    
    func formatAsCurrency() -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? "N/A"
    }
}

extension String {
    var withoutHtmlTags: String {
        return self.replacingOccurrences(of: "&[^;]+;", with: "", options: String.CompareOptions.regularExpression, range: nil)
    }
}
extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    func toFloat() -> Float? {
        return NumberFormatter().number(from: self)?.floatValue
    }
}

extension String {
    func toDate(dateFormat:String = "yyyy-MM-dd'T'HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(identifier: "CET")
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func getFormattedDate(format: String, timezone:String="CET") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "lv_LV") //Locale.current
        dateFormatter.dateFormat = format
//        dateFormatter.timeZone = TimeZone(identifier: timezone)
        return dateFormatter.string(from: self)
    }
}
extension Date {
    static func getCurrentDate(timezone:String="CET") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
//        dateFormatter.timeZone = TimeZone(identifier: timezone)
        return dateFormatter.string(from: Date())
        
    }
    
    static func getCurrentHour() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        dateFormatter.timeZone = TimeZone.current
        return "\(dateFormatter.string(from: Date())):00-\(dateFormatter.string(from: Date.now.adding(hours: 1))):00"
    }
    
    func adding(hours: Int) -> Date {
        Calendar.current.date(byAdding: .hour, value: hours, to: self)!
    }
}

extension String {
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
