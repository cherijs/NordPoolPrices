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
    @Published var rows: [NordPoolRow] = []
    @Published var title: String = "LV"
    @Published var max: Double = 0
    @Published var min: Double = 0
    @Published var average: Double = 0
    @Published var peak: Double = 0
    @Published var off_peak_1: Double = 0
    @Published var off_peak_2: Double = 0
    @Published var markets: [String] = ["LV"]
    
    var loading = false
    
    func set_min_max() {
        if(self.rows.count<=0){
            return
        }
  
        let min = self.rows.filter { row in
            return row.symbol == "Min"
        }
        self.min = min[0].price
        
        self.markets = min[0].stock.columns.map({ col in
            col.name
        })
        
        let max = self.rows.filter { row in
            return row.symbol == "Max"
        }
        self.max = max[0].price
        
        let average = self.rows.filter { row in
            return row.symbol == "Average"
        }
        self.average = average[0].price
        
        let peak = self.rows.filter { row in
            return row.symbol == "Peak"
        }
        self.peak = peak[0].price
        
        let off_peak_1 = self.rows.filter { row in
            return row.symbol == "Off-peak 1"
        }
        self.off_peak_1 = off_peak_1[0].price
        
        let off_peak_2 = self.rows.filter { row in
            return row.symbol == "Off-peak 2"
        }
        self.off_peak_2 = off_peak_2[0].price
    }
    
    func refresh() {
        if((self.response) != nil){
            self.rows = self.response.data.rows.map(NordPoolRow.init)
            self.set_min_max()
            print("REFRESH")
        }
    }
    
    func populateNordPoolStocks() async {
    
        
        let calendar = Calendar.current
        var todayStartDate = Date()
        var interval = TimeInterval()
        _ = calendar.dateInterval(of: .day, start: &todayStartDate, interval: &interval, for: Date())
        _ = calendar.date(byAdding: .second, value: Int(interval-1), to: todayStartDate)!
        if(self.loading){
            print("Loading")
            return
        }
        
        if(self.rows.count>0 && todayStartDate == self.rows[0].start_time){
            print("Already loaded")
            self.rows = self.response.data.rows.map(NordPoolRow.init)
            self.set_min_max()
            return
        }
        
        print("Fetch")
        self.loading = true
        do {
            self.response = try await Fetcher().getNordPoolStocks(url: Constants.Urls.nordpoolPrices)
            self.rows = self.response.data.rows.map(NordPoolRow.init)
            //            self.title = String(self.rows[0].description).originToString(dateFormat: "dd-MM-y")
            self.title = String(self.rows[0].description)
            self.set_min_max()
            self.loading = false
        } catch {
            print(error)
            self.loading = false
        }
        
    }
}
