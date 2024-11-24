//
//  AddBudgetScreen.swift
//  BudgetApp
//
//  Created by Andrei Motan on 13/10/24.
//

import SwiftUI
import Supabase

struct AddBudgetScreen: View {
    
    @State private var name: String = ""
    @State private var limit: Double?
    
    @Environment(BudgetsTrackerStore.self) private var budgetStore
    @Environment(\.dismiss) private var dismiss
    @Environment(\.authClient) private var authClient
    
    private func saveBudget() async {
        guard let limit = limit else { return }
        guard let currentUser = authClient.currentUser else {
                    return
                }
        
        let budget = Budget(name: name, limit: limit, userId: currentUser.id)
        
        do {
            try await budgetStore.addBudget(budget)
            dismiss()
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        Form {
            TextField("Enter name", text: $name)
            TextField("Enter limit", value: $limit, format: .number)
                .keyboardType(.decimalPad)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    Task {
                        await saveBudget()
                    }
                }
            }
        }
    }
}

/*#Preview {
    NavigationStack {
        AddBudgetScreen()
    }.environment(BudgetsTrackerStore(supabaseClient: .development))
        .environment(ExpensesTrackerStore(supabaseClient: .development, budgetsTrackerStore: <#BudgetsTrackerStore#>))
}*/

#Preview {
    let budgetsStore = BudgetsTrackerStore(supabaseClient: .development)
    //let expensesStore = ExpensesTrackerStore(supabaseClient: .development, budgetsTrackerStore: budgetsStore)

    NavigationStack {
        AddBudgetScreen()
            .environment(budgetsStore)      // Usa environmentObject
            //.environment(expensesStore)      // Usa environmentObject
    }
}
