//
//  StockListViewModel.swift
//  NordPool
//
//  Created by Arturs Cirsis on 16/09/2022.
//

import Foundation

@MainActor
class StockListViewModel: ObservableObject {
    
    @Published var response: NordPoolResponse!
    @Published var np_stocks: [NordpoolViewModel] = []
    @Published var title: String = "LV"
    @Published var current_hour_range: String = ""
    var loading = false
    
    func populateNordPoolStocks() async {
        
        self.current_hour_range = Date.getCurrentHour()
        
        let calendar = Calendar.current
        var todayStartDate = Date()
        var interval = TimeInterval()
        _ = calendar.dateInterval(of: .day, start: &todayStartDate, interval: &interval, for: Date())
        _ = calendar.date(byAdding: .second, value: Int(interval-1), to: todayStartDate)!
        if(self.loading){
            print("Loading")
            return
        }
        
        if(self.np_stocks.count>0 && todayStartDate == self.np_stocks[0].start_time){
            print("Already loaded")
            self.np_stocks = self.response.data.rows.map(NordpoolViewModel.init)
            return
        }
        
        print("Fetch")
        self.loading = true
        do {
            self.response = try await Fetcher().getNordPoolStocks(url: Constants.Urls.nordpoolPrices)
            self.np_stocks = self.response.data.rows.map(NordpoolViewModel.init)
            //            self.title = String(self.np_stocks[0].description).originToString(dateFormat: "dd-MM-y")
            self.title = String(self.np_stocks[0].description)
            self.loading = false
        } catch {
            print(error)
            self.loading = false
        }
        
    }
}


struct NordpoolViewModel: Equatable {
    static func == (lhs: NordpoolViewModel, rhs: NordpoolViewModel) -> Bool {
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
        
        self.price = stock.columns[0].value.toDouble()!/1000
        
        let filtered = stock.columns.filter { col in
            return col.name == "LV" //Date.getCurrentDate()
        }
        if(filtered.count>0){
            self.description = filtered[0].name
            self.price = filtered[0].value.toDouble()!/1000
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
