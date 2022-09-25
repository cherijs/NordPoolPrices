//
//  Date.swift
//  NordPoolMarketData
//
//  Created by Arturs Cirsis on 25/09/2022.
//

import Foundation

extension Date {
    func getFormattedDate(format: String, timezone:String="CET") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "lv_LV") //Locale.current
        dateFormatter.dateFormat = format
//        dateFormatter.timeZone = TimeZone(identifier: timezone)
        return dateFormatter.string(from: self)
    }

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
