//
//  ContentView.swift
//  Expense Tracking App
//
//  Created by Sarthak Aggarwal on 2/28/24.
//

import SwiftUI
import SwiftData
import Charts

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var expensearr: [ExpenseDetail]
    
    @State var threshold = 0.0
    @State var isShowingSheet = false
    @State var isShowingDataEntry = false
    @State var newThreshold = ""
    
    //Data entry
    @State var Tamount: String = ""
    @State var Ttype: String = ""
    @State var Tdate: Date = Date()
    @State var Tdesc: String = ""
    @State var Tlabel: String = ""
    @State var showingSaveAlert = false
    
    // Report View
    @State var isShowingReport = false
    @State var isShowingReport2 = false
    @State var TypePicker = 0
    @State var Duration = 0
    @State var calendar = Calendar.current
    @State var today = Date()
    
    @State private var StartDate = Date()
    @State private var StopDate = Date()
    
    private func getStatus(date: Date) -> Bool{
        return date >= StartDate && date <= StopDate && date >= oneMonthAgo(today: today);
    }
    
    var body: some View {
        NavigationView{
            VStack{
                Image("walletPic").resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                    .padding()
                Text("")
                Text("Balance: $\(String(format: "%.2f", getTotal(arr: expensearr)))")
                Text("")
                Text("Current Threshold: $\(String(format: "%.2f", threshold))")
                Button("Update Threshold"){
                    isShowingSheet.toggle()
                }.sheet(isPresented: $isShowingSheet){
                    HStack{
                        Spacer()
                        TextField("New Threshold", text: $newThreshold)
                        Spacer()
                    }
                    
                    Button("Save"){
                        threshold = Double(newThreshold)!
                        isShowingSheet = false
                    }
                }.presentationDetents([.medium, .large])
                Spacer()

                Button("Expense Report"){isShowingReport.toggle()}.sheet(isPresented: $isShowingReport){
                    Spacer()
                    Text("Enter the date range:")
                    Spacer()
                    DatePicker(
                        "From",
                        selection: $StartDate
                    )
                    .datePickerStyle(CompactDatePickerStyle())
                    .frame(maxHeight: 400)
                    Spacer()
                    DatePicker(
                        "Till",
                        selection: $StopDate
                    )
                        .datePickerStyle(CompactDatePickerStyle())
                        .frame(maxHeight: 400)
                    
                    Spacer()
                    Spacer()
                    Text(StartDate.ISO8601Format()+StopDate.ISO8601Format()).foregroundStyle(.white)        .font(.system(size: 1))
                    
                    Button("Show"){isShowingReport2.toggle()}.sheet(isPresented: $isShowingReport2){
                        Picker(selection: $TypePicker, label: Text("someText")){
                            Text("Expenses").tag(0)
                            Text("Income").tag(1)
                        }.pickerStyle(SegmentedPickerStyle())
                        /* Here I want to choose different views depending on the item selected */
                        if(TypePicker == 0){
                            Text("Total Expense: $\(String(format: "%.2f", CalcExp(data: expensearr)))")
                            List(expensearr, id: \.amount){ transaction in
                                if(transaction.type == "Expense"){
                                    if(getStatus(date:transaction.date)){
                                        VStack{
                                            Text("")
                                            Text("Expense Label: \(transaction.label)")
                                            Text("Expense Amount: $\(transaction.amount)")
                                            Text("Expense Date: \(transaction.date)")
                                            Text("Expense Description: \(transaction.desc)")
                                            Text("")
                                        }
                                    }
                                }
                            }
                        }else if(TypePicker == 1){
                            Text("Total Income: $\(String(format: "%.2f", CalcInc(data: expensearr)))")
                            List(expensearr, id: \.amount){ transaction in
                                if(transaction.type == "Income"){
                                    if(transaction.date >= StartDate && transaction.date <= StopDate && transaction.date >= oneMonthAgo(today: today)){
                                        VStack{
                                            Text("")
                                            Text("Expense Label: \(transaction.label)")
                                            Text("Expense Amount: $\(transaction.amount)")
                                            Text("Expense Date: \(transaction.date)")
                                            Text("Expense Description: \(transaction.desc)")
                                            Text("")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                Spacer()
                
                
                
            }.navigationBarTitle("Expense Tracker")
                .navigationBarItems(leading: Button("Add") {isShowingDataEntry.toggle()}).sheet(isPresented: $isShowingDataEntry){
                    Form{
                        Section(header: Text("Expense Details")){
                            TextField("Transaction Label", text: $Tlabel)
                            Picker("Transaction Type", selection: $Ttype) {
                                Text("Expense").tag("Expense")
                                Text("Income").tag("Income")
                            }
                            .pickerStyle(.menu)
                            TextField("Transaction amount", text: $Tamount)
                            DatePicker(
                                "Transaction date",
                                selection: $Tdate
                            )
                            .datePickerStyle(CompactDatePickerStyle())
                            .frame(maxHeight: 400)
                            
                            TextField("Description", text: $Tdesc)
                        }
                        Button("Save Transaction"){
                            let transaction = ExpenseDetail(desc: Tdesc, amount: Tamount, type: Ttype, date: Tdate, label: Tlabel)
                            if(Tdate >= oneMonthAgo(today: today)){
                                modelContext.insert(transaction)
                            }
                            showingSaveAlert = true
                        }.alert(isPresented: $showingSaveAlert) {
                            if(Calc(data: expensearr) < 0 && CalcExp(data: expensearr) > threshold){
                                return Alert(title: Text("Alert!"), message: Text("You spent too much!."), dismissButton: .default(Text("OK")))
                            }
                            else if(Calc(data: expensearr) > 0 && CalcExp(data: expensearr) < threshold){
                                return Alert(title: Text("Great!"), message: Text("You saved some good money."), dismissButton: .default(Text("OK")))
                            }
                            else{
                                return Alert(title: Text("Saved!"), message: Text("Your transaction has been saved."), dismissButton: .default(Text("OK")))
                            }
                        }
                        
                    }
                }
            
        }
    }
    func getTotal(arr: [ExpenseDetail])->Double{
        var total = 0.0
        for exp in arr{
            if(exp.type == "Expense"){
                total = total - Double(exp.amount)!
            }
            else{
                total = total + Double(exp.amount)!
            }
        }
        return total
    }
    
    func oneMonthAgo(today: Date)-> Date{
        let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: today)
        return oneMonthAgo!
    }
}
