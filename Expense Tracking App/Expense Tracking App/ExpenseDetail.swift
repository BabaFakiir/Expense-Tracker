//
//  ExpenseDetail.swift
//  Expense Tracking App
//
//  Created by Sarthak Aggarwal on 2/28/24.
//

import Foundation
import SwiftData
enum TransactionType: String, CaseIterable {
    case income = "Income"
    case expense = "Expense"
}

@Model class ExpenseDetail{
    @Attribute var amount: String = ""
    @Attribute var type: String = ""
    @Attribute var date: Date
    @Attribute var desc: String = ""
    @Attribute var label: String = ""
    
    init(desc: String, amount: String, type: String, date: Date, label:String) {
            self.desc = desc
            self.amount = amount
            self.type = type
            self.date = date
            self.label = label
        }
}
