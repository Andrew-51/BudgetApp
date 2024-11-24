//
//  ExpensesListView.swift
//  BudgetApp
//
//  Created by Andrei Motan on 03/11/24.
//

import SwiftUI

struct ExpensesListView: View {
    
    let expenses: [Expense]
    @State private var selectedExpense: Expense?
    @Environment(BudgetsTrackerStore.self) private var store
    
    private var total: Double {
        expenses.reduce(0){ result, expense in
            result + expense.amount
        }
    }
    
    private func deleteExpense(_ indexSet: IndexSet) {
        
        guard let index = indexSet.first else { return }
        let expense = expenses[index]
        
        Task {
            do {
                try await store.deleteExpense(expense)
            } catch {
                print(error)
            }
        }
        
    }
    
    var body: some View {
        List {
            
            if(expenses.isEmpty) {
                Text("No expenses yet")
            } else {
                HStack {
                    Spacer()
                    Text("Total: ")
                    Text(total,  format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))
                    Spacer()
                }
                .bold()
            }
            
            ForEach(expenses) { expense in
                ExpenseCellView(expense: expense)
                    .onTapGesture {
                        selectedExpense = expense
                    }
            }.onDelete(perform: deleteExpense)
        }
        .sheet(item: $selectedExpense){ selectedExpense in
            ExpenseDetailScreen(expense: selectedExpense)
                .presentationDetents([.medium])
        }
    }
}

struct ExpenseCellView: View {
    let expense: Expense
    
    var body: some View {
        HStack {
            Text(expense.name)
            Spacer()
            Text(expense.amount, format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    ExpensesListView(expenses: [Expense(id: 1, name: "String", amount: 0.59, budgetId: 14),Expense(id: 2, name: "String 2", amount: 10.50, budgetId: 14),Expense(id: 3, name: "String 3", amount: 15, budgetId: 14)])
        .environment(BudgetsTrackerStore(supabaseClient: .development))
}
