//
//  Expense_Tracking_AppApp.swift
//  Expense Tracking App
//
//  Created by Sarthak Aggarwal on 2/28/24.
//

import SwiftUI
import SwiftData
import SwiftData
import CoreData
@main
struct Expense_tracking_App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ExpenseDetail.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
