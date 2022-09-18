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
    
    
    private var stock: Row
    var start_time: Date
    var end_time: Date
    var description: String
    var price: Double
    var is_active: Bool = true
    var is_past: Bool = false
    
    init(stock: Row) {
        self.stock = stock
        self.start_time = stock.startTime.toDate()!
        self.end_time = stock.endTime.toDate()!
        //        .getFormattedDate(format: "HH:mm")
        
        self.price = stock.columns[0].value.toDouble()! // /1000
        
        let filtered = stock.columns.filter { col in
            return col.name == "LV" //Date.getCurrentDate()
        }
        if(filtered.count>0){
            self.description = filtered[0].name
            self.price = filtered[0].value.toDouble()! //  /1000
        } else {
            self.description = ""
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
