//
//  ContentView.swift
//  NordPool
//
//  Created by Arturs Cirsis on 16/09/2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm: StockListViewModel
    @State private var scrollTarget = ""
    @State private var showingSettings = false
    
    @StateObject var app_settings:AppSettings = AppSettings()
    
    enum Mesurement: Float, CaseIterable, Identifiable {
        case kWh = 0.001, mWh = 1
        var id: Self { self }
    }
    
    @State private var selectedMesurement: Mesurement = .kWh
    
    
    enum Markets: String, CaseIterable, Identifiable {
        case SYS, SE1, SE2, SE3, SE4, FI, DK1, DK2, Oslo, Krsand = "Kr.sand", Bergen, Molde, Trheim = "Tr.heim", Tromsø, EE, LV, LT, AT, BE, DELU = "DE-LU", FR, NL
        var id: Self { self }
    }
    @State private var selectedMarket: Markets = .LV
    
    init(vm: StockListViewModel) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    func saveSettings()  {
            app_settings.saveSettings(market: selectedMarket.rawValue, mesurement: selectedMesurement.rawValue)
            print("saveSettings DONE:")
            self.vm.refresh()
    }
    
    @ViewBuilder
    func FooterBar()->some View{
        Button(action: {
            scrollTarget = Date.getCurrentHour()
        }, label : {
            HStack(alignment: .center, spacing: 3){
                Text("Min \(vm.min.formatAsCurrency())")
                Spacer()
                Text("Max \(vm.max.formatAsCurrency())")
            }
        })
        .padding(.horizontal)
        .padding(.top,10)
        .opacity(0.7)
        if(showingSettings){
            HStack {
                Picker(selection: $selectedMesurement, label: EmptyView()) {
                    Text("kWh").tag(Mesurement.kWh)
                    Text("mWh").tag(Mesurement.mWh)
                }.onChange(of: selectedMesurement) { tag in
                    print("\(tag.rawValue)")
                    
                    self.saveSettings()
                    
                }
                .pickerStyle(.segmented)
                
                Picker(selection: $selectedMarket, label: EmptyView()) {
                    ForEach(Markets.allCases) { option in
                        Text(option.rawValue.description)
                    }
                }.onChange(of: selectedMarket) { tag in
                    print("\(tag.rawValue)")
                    self.saveSettings()
                }
            }.padding(.horizontal).padding(.top, 0)
        }
        Spacer()
        HStack{
            Button{
                showingSettings = !showingSettings
            } label: {
                Image(systemName: "gearshape.fill")
            }
            Spacer()
            Button{
                NSApplication.shared.terminate(nil)
            } label: {
                Image(systemName: "power")
            }
            //
        }
        .padding(.horizontal)
        .padding(.bottom,10)
        .padding(.top,0)
    }
    
    
    @ViewBuilder
    func Header()->some View{
        Button(action: {
            scrollTarget = Date.getCurrentHour()
        }, label : {
            HStack(alignment: .top){
                Text("Nord Pool")
                Spacer()
                Text(app_settings.market)
            }.padding()
        })
        
    }
    
    
    var body: some View {
        ScrollViewReader { (proxy: ScrollViewProxy) in
            VStack(alignment: .leading){
                Header()
                Spacer(minLength: 0)
                List(vm.rows.filter { $0.is_active && !["Min", "Max", "Average", "Peak", "Off-peak 1", "Off-peak 2"].contains($0.symbol)   }, id: \.range) { stock in
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text("\(stock.range)")
                                .fontWeight(Date.getCurrentHour() == stock.range ? .bold : .light)
                                .opacity(Date.getCurrentHour() == stock.range ? 1 : 0.4)
                        }
                        Spacer()
                        HStack{
                            Text(stock.price.formatAsCurrency()).fontWeight(Date.getCurrentHour() == stock.range ? .bold : .light)
                            Circle().fill(stock.price < vm.off_peak_1 ? Color.green : stock.price > vm.off_peak_2 ? Color.red : Color.white.opacity(0.2))
                                .frame(width: 4, height: 4)
                            
                        }.opacity(stock.is_past ? 0.4 : 1)
                        
                    }
                    Divider()
                }
                .onChange(of: vm.rows) { new_rows in
                    print("changed vm.rows")
                    withAnimation {
                        proxy.scrollTo(Date.getCurrentHour(), anchor: .leading)
                    }
                }
                .onChange(of: scrollTarget) { target in
                    //                print("onChange - \(scrollTarget)  \(target)")
                    if (target != ""){
                        scrollTarget = ""
                        withAnimation {
                            proxy.scrollTo(target, anchor: .center)
                        }
                    }
                }
                Spacer(minLength: 0)
                FooterBar()
            }.frame(width: 200, height: 230)
                .preferredColorScheme(.dark)
                .buttonStyle(.plain)
        }
        .onChange(of: showingSettings){ target in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if(!target){
                    scrollTarget = Date.getCurrentHour()
                } else{
                    scrollTarget = ""
                }
            }
        }.onAppear() {
            selectedMesurement = Mesurement(rawValue: app_settings.mesurement) ?? .kWh
            selectedMarket = Markets(rawValue: app_settings.market) ?? .LV
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(vm: StockListViewModel())
    }
}
