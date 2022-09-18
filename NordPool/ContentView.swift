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
    
    init(vm: StockListViewModel) {
        self._vm = StateObject(wrappedValue: vm)
        
    }
    
    func updateScrollTarget(target:String){
        print("updateScrollTarget " + target)
//        TODO
//        scrollTarget = target
//        self._scrollTarget = State(initialValue: target)
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
//                   Button(vm.title) {
//                       scrollTarget = vm.current_hour_range
//                   }
               }.padding()
           })
        
    }
    
    @ViewBuilder
    func FooterBar()->some View{
        HStack{
            Button{
                
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
        .padding(.vertical,10)
    }
    
    
    var body: some View {
        ScrollViewReader { (proxy: ScrollViewProxy) in
            VStack(alignment: .leading, spacing: 0) {
                Header()
                List(vm.rows.filter { $0.is_active }, id: \.symbol) { stock in
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text(stock.symbol)
                                .opacity(0.4)
                            //                            .fontWeight(.semibold)
                            //                        Text(stock.description)
                            //                            .opacity(0.4)
                            //                        Divider()
                        }
                        Spacer()
                        if(stock.is_past){
                            Text(stock.price.formatAsCurrency()).opacity(0.4)
                        } else {
                            Text(stock.price.formatAsCurrency())
                        }
                        
                    }
                    Divider()
                }
                FooterBar()
            }.frame(width: 150, height: 200)
            .onChange(of: vm.rows) { new_rows in
                print("changed vm.rows")
                withAnimation {
                    proxy.scrollTo(Date.getCurrentHour(), anchor: .top)
                }
            }
            .onChange(of: scrollTarget) { target in
//                print("onChange - \(scrollTarget)  \(target)")
                if (target != ""){
                    scrollTarget = ""
                    withAnimation {
                        proxy.scrollTo(target, anchor: .top)
                    }
                }
            }
            .preferredColorScheme(.dark)
            .buttonStyle(.plain)
            
        }.task {
            // FIRST TIME
            await vm.populateNordPoolStocks()
//            scrollTarget = vm.current_hour_range
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(vm: StockListViewModel())
    }
}
