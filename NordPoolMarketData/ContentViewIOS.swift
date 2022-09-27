//
//  ContentView.swift
//  NordPoolMarketData
//
//  Created by Arturs Cirsis on 25/09/2022.
//

import SwiftUI

#if os(iOS)
struct ContentViewIOS: View {
    
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
        .padding(.horizontal,18)
        .padding(.top,10)
        .opacity(0.7)
        
    }
    
    @ViewBuilder
    func Settings()->some View{
        VStack{
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
            }.pickerStyle(.inline)
        }.padding(.horizontal).padding(.top, 0)
        
        
        
    }
    @ViewBuilder
    func Header()->some View{
        NavigationLink(destination: Settings(), isActive: $showingSettings){
            EmptyView()
        }
//        HStack{
//            Button{
//                showingSettings = !showingSettings
//            } label: {
//                Image(systemName: "gearshape.fill")
//            }
//            Spacer()
//
//        }
//        .padding(.horizontal)
//        .padding(.bottom,10)
//        .padding(.top,0)
        
        //        Button(action: {
        //            scrollTarget = Date.getCurrentHour()
        //        }, label : {
        //            HStack(alignment: .top){
        //                Text("Nord Pool")
        //                Spacer()
        //                Text(app_settings.market)
        //            }
        //            .padding(18)
        //        })
        
    }
    
    
    var body: some View {
        NavigationView{
            ScrollViewReader { (proxy: ScrollViewProxy) in
                VStack(alignment: .leading){
                    
                    Header()
                    
                    List(vm.rows.filter { $0.is_active && !["Min", "Max", "Average", "Peak", "Off-peak 1", "Off-peak 2"].contains($0.symbol)   }, id: \.range) { stock in
                        
                        VStack(){
                            HStack(alignment: .center) {
                                VStack(alignment: .leading) {
                                    Text(stock.day)
                                    
                                    
                                        .opacity(0.4)
                                    Text("\(stock.range)")
                                        .fontWeight(Date.getCurrentHour() == stock.range ? .semibold : .light)
                                        .opacity(Date.getCurrentHour() == stock.range ? 1 : 0.4)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 0) {
                                    if(stock.price < vm.off_peak_1){
                                        Image(systemName: "arrow.down.circle.fill")
                                            .resizable()
                                            .foregroundStyle(Color.green)
                                            .frame(width: 8, height:8).padding(.vertical, 2)
                                    } else if (stock.price > vm.off_peak_2) {
                                        Image(systemName: "arrow.up.circle.fill")
                                            .resizable()
                                            .foregroundStyle(Color.red)
                                            .frame(width: 8, height:8).padding(.vertical, 2)
                                    } else {
                                        Image(systemName: "arrow.up.backward.and.arrow.down.forward.circle.fill")
                                            .resizable()
                                            .foregroundStyle(Color.white.opacity(0.2))
                                            .frame(width: 8, height:8).padding(.vertical, 2)
                                    }
                                    
                                    
                                    //                            Circle().fill(stock.price < vm.off_peak_1 ? Color.green : stock.price > vm.off_peak_2 ? Color.red : Color.white.opacity(0.2))
                                    //                                .frame(width: 4, height: 4).padding(.vertical, 4)
                                    HStack(){
                                        Text(stock.price.formatAsCurrency()).fontWeight(Date.getCurrentHour() == stock.range ? .semibold : .light)
                                        
                                    }.opacity(stock.is_past ? 0.4 : 1)
                                }
                                
                            }
                            Divider()
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(PlainListStyle())
                    //                .border(.red)
                    .onChange(of: vm.rows) { new_rows in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation {
                                proxy.scrollTo(Date.getCurrentHour(), anchor: .leading)
                            }
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
                }
                .buttonStyle(.plain)
                
            }
            .navigationBarTitle("Market data", displayMode: .large)
            .navigationBarItems(trailing:  HStack {
                Button(action: {
                    showingSettings = !showingSettings
                }) {
                    Image(systemName: "gearshape.fill")
                        .imageScale(.large)
                }
            }
            )
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
        ContentViewIOS(vm: AppDelegate.instance.stockListVM)
    }
}
#endif
