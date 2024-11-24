//
//  ExpensesTrackerStore.swift
//  BudgetApp
//
//  Created by Andrei Motan on 03/11/24.
//

import Foundation
import Observation
import Supabase
/*
@Observable
class ExpensesTrackerStore {
    /*
    var budgetsTrackerStore: BudgetsTrackerStore
    var supabaseClient: SupabaseClient
    
    init(supabaseClient: SupabaseClient, budgetsTrackerStore: BudgetsTrackerStore) {
        self.supabaseClient = supabaseClient
        self.budgetsTrackerStore = budgetsTrackerStore
    }
    
    private var budgets: [Budget] {
        return budgetsTrackerStore.budgets
    }

    func addExpense(_ expense: Expense) async throws {
        let budgetIdString = String(describing: expense.budgetId)
        print("ExpensesTrackerStore - addExpense: \(String(describing: budgetIdString))")
        
        let newExpense: Expense = try await supabaseClient
            .from("expenses")
            .insert(expense)
            .select()
            .single()
            .execute()
            .value
        
        guard let index = budgets.firstIndex(where: { $0.id == expense.budgetId }) else {
            print("budgets.firstIndex(where: {$0.id == expense.budgetId}) \(String(describing: budgets.firstIndex(where: {$0.id == expense.budgetId})))")
            throw BudgetError.errorCreating
        }
        
        // Utilizza il metodo di BudgetsTrackerStore per aggiornare le spese
        budgetsTrackerStore.updateExpenses(expenseId: expense.budgetId, updatedValues: [newExpense])
    }
    
    func loadExpenses(by budgetId: Int) async throws {
        print("ExpensesTrackerStore - loadExpenses: \(budgetId)")
        
        let expenses: [Expense] = try await supabaseClient
            .from("expenses")
            .select()
            .eq("budget_id", value: budgetId)
            .execute()
            .value
        
        print("Expenses loaded:", expenses)
        print("Current budgets:", budgets)
        
        // Usa il metodo di BudgetsTrackerStore per aggiornare le spese
        budgetsTrackerStore.updateExpenses(expenseId: budgetId, updatedValues: expenses)
    }*/
}
*/
