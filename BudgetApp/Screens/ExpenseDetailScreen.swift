//
//  ExpenseDetailScreen.swift
//  BudgetApp
//
//  Created by Andrei Motan on 17/11/24.
//

import SwiftUI

struct ExpenseDetailScreen: View {
    
    let expense: Expense
    
    @Environment(BudgetsTrackerStore.self) private var budgetStore
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var amount: Double?
    
    private func updateExpense() async {
        
        guard let expenseId = expense.id,
              let amount = amount else { return }
        
        let updatedValue = Expense(name: name, amount: amount, budgetId: expense.budgetId)
        
        do {
            try await budgetStore.updateExpenses(expenseId: expenseId, updatedValues: updatedValue)
        } catch {
            print(error)
        }
        
    }
    
    var body: some View {
        Form {
            TextField("Expense name", text: $name)
            TextField("Expense amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))
            HStack {
                Button("Cancel") {
                    print("dismiss")
                    dismiss()
                }
                Spacer()
                Button("Update"){
                    Task {
                        await updateExpense()
                    }
                }
            }
        }
        .onAppear(perform: {
            name = expense.name
            amount = expense.amount
        })
    }
}

#Preview {
    ExpenseDetailScreen(expense: Expense(name: "Test", amount: 5.0, budgetId: 16))
        .environment(BudgetsTrackerStore(supabaseClient: .development))
}
