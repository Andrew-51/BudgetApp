//
//  BudgetDetailsScreen.swift
//  BudgetApp
//
//  Created by Andrei Motan on 13/10/24.
//

import SwiftUI
import os

struct BudgetDetailsScreen: View {
    let budget: Budget
    
    @Environment(\.dismiss) private var dismiss
    @Environment(BudgetsTrackerStore.self) private var budgetStore
    @Environment(\.authClient) private var authClient
    //@Environment(ExpensesTrackerStore.self) private var expenseStore
    
    @State private var name: String = ""
    @State private var limit: Double?
    @State private var isPresented: Bool = false
    
    private func updateBudget() async {
        
        guard let limit = limit,
              let id = budget.id
        else { return }
        
        guard let currentUser = authClient.currentUser else {
                    return
                }
        
        let updatedValues = Budget(name: name, limit: limit, userId: currentUser.id)
        
        do {
            try await budgetStore.updateBudget(id: id, updatedValues: updatedValues)
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        Form {
            TextField("Enter name", text: $name)
            TextField("Enter limit", value: $limit, format: .number)
                .keyboardType(.decimalPad)
            Spacer()
            Button("Update"){
                Task {
                    await updateBudget()
                }
            }
            
            Section("Expenses") {
                if let expenses = budgetStore.budgets.first(where: { $0.id == budget.id })?.expenses.map(\.self) {
                    ExpensesListView(expenses: expenses)
                }
            }
        }
        .task {
            guard let budgetId = budget.id else {return}
            //os_log("budgetId: \(budgetId)")
            
            do {
                print("budgetId in BudgetDetailsScreen: \(budgetId)")
                try await budgetStore.loadExpenses(by: budgetId)
            } catch {
                print(error)
            }
        }
        .onAppear(perform: {
            name = budget.name
            limit = budget.limit
        })
        .navigationTitle(budget.name)
        .sheet(isPresented: $isPresented, content: {
            NavigationStack {
                AddExpenseScreen(budget: budget)
            }
        })
        .toolbar{
            ToolbarItem(placement: .topBarTrailing, content: {
                Button("Add Expense"){
                    isPresented = true
                }
            })
        }
    }
}

/*#Preview {
    NavigationStack{
        BudgetDetailsScreen(budget: Budget(name: "Budget details - name", limit: 11.00))
    }
    .environment(BudgetsTrackerStore(supabaseClient: .development))
    .environment(ExpensesTrackerStore(supabaseClient: .development))
}*/

#Preview {
    let budgetsStore = BudgetsTrackerStore(supabaseClient: .development)
    //let expensesStore = ExpensesTrackerStore(supabaseClient: .development, budgetsTrackerStore: budgetsStore)

    NavigationStack {
        BudgetDetailsScreen(budget: Budget(name: "Budget details - name", limit: 11.00, userId: UUID()))
            .environment(budgetsStore)      // Usa environmentObject
            //.environment(expensesStore)      // Usa environmentObject
    }
}
