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
    
    var mesurements = ["kWh", "mWh"]
    @State private var selectedMesurmentIndex = 0
    
    
    init(vm: StockListViewModel) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    @ViewBuilder
    func FooterBar()->some View{
        HStack(alignment: .center, spacing: 3){
            Text("Min \(vm.min.formatAsCurrency())")
            Spacer()
            Text("Max \(vm.max.formatAsCurrency())")
        }
        .padding(.horizontal)
        .padding(.top,10)
        .padding(.bottom,10)
        .opacity(0.7)
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
            scrollTarget = vm.current_hour_range
        }, label : {
            HStack(alignment: .top){
                Text("Nord Pool")
                Spacer()
                Text(vm.title)
            }.padding()
        })
        
    }
    
    
    var body: some View {
        ScrollViewReader { (proxy: ScrollViewProxy) in
            VStack(alignment: .leading){
                Header()
                Spacer(minLength: 0)
                if(showingSettings){
                    VStack{
                        Picker(selection: $selectedMesurmentIndex, label: EmptyView()) {
                            ForEach(0 ..< mesurements.count) {
                                Text(self.mesurements[$0])
                            }
                        }
                     
                    }.padding()
                    
                    
                } else {
                    
                    List(vm.rows.filter { $0.is_active }, id: \.symbol) { stock in
                        HStack(alignment: .center) {
                            VStack(alignment: .leading) {
                                Text(stock.symbol)
                                    .fontWeight(Date.getCurrentHour() == stock.symbol ? .bold : .light)
                                    .opacity(Date.getCurrentHour() == stock.symbol ? 1 : 0.4)
                            }
                            Spacer()
                            HStack{
                                Text(stock.price.formatAsCurrency()).fontWeight(Date.getCurrentHour() == stock.symbol ? .bold : .light)
                                Circle().fill(stock.price < vm.off_peak_1 ? Color.green : stock.price > vm.off_peak_2 ? Color.red : Color.white.opacity(0.2))
                                    .frame(width: 4, height: 4)
                                
                            }.opacity(stock.is_past ? 0.4 : 1)
                            
                        }
                        Divider()
                    }.onChange(of: vm.rows) { new_rows in
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
                                proxy.scrollTo(target, anchor: .leading)
                            }
                        }
                    }
                    
                    
                    
                }
                Spacer(minLength: 0)
                FooterBar()
            }.frame(width: 200, height: 230)
                .preferredColorScheme(.dark)
                .buttonStyle(.plain)
        }.task {
            await vm.populateNordPoolStocks()
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(vm: StockListViewModel())
    }
}
