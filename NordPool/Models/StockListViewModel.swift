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
        
        if(self.rows.count>0 && todayStartDate == self.rows[0].start_time){
            print("Already loaded")
            self.rows = self.response.data.rows.map(NordPoolRow.init)
            return
        }
        
        print("Fetch")
        self.loading = true
        do {
            self.response = try await Fetcher().getNordPoolStocks(url: Constants.Urls.nordpoolPrices)
            self.rows = self.response.data.rows.map(NordPoolRow.init)
            //            self.title = String(self.rows[0].description).originToString(dateFormat: "dd-MM-y")
            self.title = String(self.rows[0].description)
            self.loading = false
        } catch {
            print(error)
            self.loading = false
        }
        
    }
}
