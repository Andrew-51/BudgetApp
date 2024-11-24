//
//  BudgetsTrackerStore.swift
//  BudgetApp
//
//  Created by Andrei Motan on 03/11/24.
//

import Foundation
import Observation
import Supabase

@Observable
class BudgetsTrackerStore {
    
    private(set) var budgets: [Budget] = []
    
    var supabaseClient: SupabaseClient
    
    init(supabaseClient: SupabaseClient) {
        self.supabaseClient = supabaseClient
    }
    
    func loadBudgets() async throws {
        
        budgets = try await supabaseClient
            .from("budgets")
            .select()
            .execute()
            .value
    }
    
    func addBudget(_ budget: Budget) async throws {
        
        let newBudget: Budget = try await supabaseClient
            .from("budgets")
            .insert(budget)
            .select()
            .single()
            .execute()
            .value
        
        budgets.append(newBudget)
    }
    
    func deleteBudget(_ budget: Budget) async throws {
        
        guard let id = budget.id else { return }
        
        try await supabaseClient
            .from("budgets")
            .delete()
            .eq("id", value: id)
            .execute()
        
        // remove budget from budgets array
        budgets = budgets.filter { $0.id! != id }
    }
    
    func updateBudget(id: Int, updatedValues: Budget) async throws {
        
        let updatedBudget: Budget = try await supabaseClient
            .from("budgets")
            .update(updatedValues)
            .eq("id", value: id)
            .select()
            .single()
            .execute()
            .value
        
        // Find the index of the budget with the matching ID
        guard let index = budgets.firstIndex(where: { $0.id == updatedBudget.id }) else {
            throw BudgetError.invalidBudgetId
        }
        
        //budgets[index].name = updatedBudget.name
        //budgets[index].limit = updatedBudget.limit

    }
    
    func addExpense(_ expense: Expense) async throws {
        
        let newExpense: Expense = try await supabaseClient
            .from("expenses")
            .insert(expense)
            .select()
            .single()
            .execute()
            .value
        
        // Find the index of the budget with the matching ID
        guard let index = budgets.firstIndex(where: { $0.id == expense.budgetId }) else {
            throw BudgetError.invalidBudgetId
        }
        
        budgets[index].expenses?.append(newExpense)
    }
    
    
    func loadExpenses(by budgetId: Int) async throws {
        
        let expenses: [Expense] = try await supabaseClient
            .from("expenses")
            .select()
            .eq("budget_id", value: budgetId)
            .execute()
            .value
        
        // Find the index of the budget with the matching ID
        guard let index = budgets.firstIndex(where: { $0.id == budgetId }) else {
            throw BudgetError.invalidBudgetId
        }
        
        budgets[index].expenses = expenses
    }
    
    func deleteExpense(_ expense: Expense) async throws {
        
        guard let expenseId = expense.id else {
            throw ExpenseError.invalidExpenseId
        }
        
        try await supabaseClient
            .from("expenses")
            .delete()
            .eq("id", value: expenseId)
            .execute()
        
        // Find the index of the budget with the matching ID
        guard let index = budgets.firstIndex(where: { $0.id == expense.budgetId }) else {
            throw BudgetError.invalidBudgetId
        }
        
        budgets[index].expenses = budgets[index].expenses?.filter { $0.id != expenseId }
    }
    
    func updateExpenses(expenseId: Int, updatedValues: Expense) async throws {
        
        let updatedExpense: Expense = try await supabaseClient
            .from("expenses")
            .update(updatedValues)
            .eq("id", value: expenseId)
            .select()
            .single()
            .execute()
            .value
        
        // Find the index of the budget with the matching ID
        guard let budgetIndex = budgets.firstIndex(where: { $0.id == updatedExpense.budgetId }) else {
            throw BudgetError.invalidBudgetId
        }
        
        guard let expenseIndex = budgets[budgetIndex].expenses?.firstIndex(where: { $0.id == updatedExpense.id }) else {
            throw ExpenseError.invalidExpenseId
        }
        
        budgets[budgetIndex].expenses?[expenseIndex] = updatedExpense
    }
}
