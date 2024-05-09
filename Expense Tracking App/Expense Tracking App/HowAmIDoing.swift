//
//  HowAmIDoing.swift
//  Expense Tracking App
//
//  Created by Sarthak Aggarwal on 4/6/24.
//

import SwiftUI

func Calc(data: [ExpenseDetail]) -> Double{
    var total: Double = 0.0
    for transaction in data{
        if(transaction.type == "Expense"){
            total = total - Double(transaction.amount)!
        }
        else if(transaction.type == "Income"){
            total = total + Double(transaction.amount)!
        }
    }
    return total
}

func CalcExp(data: [ExpenseDetail]) -> Double{
    var total: Double = 0.0
    for transaction in data{
        if(transaction.type == "Expense"){
            total = total + Double(transaction.amount)!
        }
    }
    return total
}

func CalcInc(data: [ExpenseDetail]) -> Double{
    var total: Double = 0.0
    for transaction in data{
        if(transaction.type == "Income"){
            total = total + Double(transaction.amount)!
        }
    }
    return total
}
