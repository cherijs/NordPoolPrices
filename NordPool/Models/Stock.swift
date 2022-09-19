//
//  Stock.swift
//  NordPool
//
//  Created by Arturs Cirsis on 16/09/2022.
//

import Foundation

struct NordPoolRow: Equatable {
    static func == (lhs: NordPoolRow, rhs: NordPoolRow) -> Bool {
        return lhs.price == rhs.price && lhs.is_active == rhs.is_active && lhs.is_past == rhs.is_past
    }
    
    
    var stock: Row
    var start_time: Date
    var end_time: Date
    var description: String
    var price: Double
    var is_active: Bool = true
    var is_past: Bool = false
    
    init(stock: Row) {
        let settings = AppSettings()
        
        self.stock = stock
        self.start_time = stock.startTime.toDate()!
        self.end_time = stock.endTime.toDate()!
        //        .getFormattedDate(format: "HH:mm")
        
        self.price = Double(stock.columns[0].value.toFloat()! * settings.mesurement)
        
        let filtered = stock.columns.filter { col in
            return col.name == settings.market //Date.getCurrentDate()
        }
        if(filtered.count>0){
            self.description = filtered[0].name
            self.price = Double(filtered[0].value.toFloat()! * settings.mesurement)
        } else {
            self.description = ""
            self.price = 0
            self.is_active = false
        }
        
        if(stock.endTime.toDate()!>Date()){
            self.is_past = false
        } else {
            self.is_past = true
        }
        
    }
    
    var symbol: String {
        stock.name.withoutHtmlTags
    }
    
    //    var price: String {
    //        stock.columns[0].value
    //    }
    
}
