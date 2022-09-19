//
//  Settings.swift
//  NordPool
//
//  Created by Arturs Cirsis on 19/09/2022.
//

import Foundation
import PromiseKit
import SwiftUI

class AppSettings:ObservableObject {
    
    @Published var market: String = "LV"
    @Published var mesurement: Float = 0.001
    
    init() {
        self.mesurement = (UserDefaults.standard.float(forKey: "mesurement") != 0) ? UserDefaults.standard.float(forKey: "mesurement") : self.mesurement
        self.market = UserDefaults.standard.string(forKey: "market") ?? "LV"
    }
    
    func clearSettings() -> Promise<String> {
        return Promise { seal in
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            self.mesurement = 0.001
            self.market = "LV"
            seal.fulfill("ok")
        }
    }
    
    func saveSettings(market: String = "LV", mesurement: Float = 0.001) -> Promise<AppSettings> {
        return Promise { seal in
            self.market = market
            self.mesurement = mesurement
            UserDefaults.standard.set(self.market, forKey: "market")
            UserDefaults.standard.set(self.mesurement, forKey: "mesurement")
            seal.fulfill(self)
        }
    }
}
