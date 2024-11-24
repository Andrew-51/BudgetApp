//
//  ContentView.swift
//  BudgetApp
//
//  Created by Andrei Motan on 13/10/24.
//

import SwiftUI
import Supabase

struct BudgetListScreen: View {
    
    //@Environment(\.supabaseClient) private var supabaseClient
    @State private var budgets: [Budget] = []
    @State private var isPresented: Bool = false
    @State private var isSettingsPresented: Bool = false
    
    @Environment(BudgetsTrackerStore.self) private var budgetsStore
    //@Environment(ExpensesTrackerStore.self) private var expensesStore
    
    var body: some View {
        List {
            ForEach(budgetsStore.budgets) { budget in
                NavigationLink {
                    BudgetDetailsScreen(budget: budget)
                } label: {
                    BudgetCellView(budget: budget)
                }
            }
            .onDelete(perform: { indexSet in
                guard let index = indexSet.last else { return }
                let budget = budgetsStore.budgets[index]
                Task {
                    do {
                        try await budgetsStore.deleteBudget(budget)
                    } catch {
                        print(error)
                    }
                }
            })
        }
        .navigationBarBackButtonHidden()
        .task {
            do {
                try await budgetsStore.loadBudgets()
            } catch {
                print(error)
            }
        }
        .navigationTitle("Budgets")
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    isSettingsPresented = true
                }, label: {
                    Image(systemName: "gear")
                })
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Budget") {
                    isPresented = true
                }
            }
        })
        .sheet(isPresented: $isSettingsPresented, content: {
            SettingsScreen()
                .presentationDetents([.medium, .large])
        })
        .sheet(isPresented: $isPresented, content: {
            NavigationStack {
                AddBudgetScreen()
            }
        })
        .refreshable {
            do {
                try await budgetsStore.loadBudgets()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    let budgetsStore = BudgetsTrackerStore(supabaseClient: .development)
    //let expensesStore = ExpensesTrackerStore(supabaseClient: .development, budgetsTrackerStore: budgetsStore)

    NavigationStack {
        BudgetListScreen()
            .environment(budgetsStore)      // Usa environmentObject
            //.environment(expensesStore)      // Usa environmentObject
    }
}


struct BudgetCellView: View {
    let budget: Budget
    var body: some View {
        HStack {
            Text(budget.name)
            Spacer()
            Text(budget.limit, format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))
        }
    }
}
