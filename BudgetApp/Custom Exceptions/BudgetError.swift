//
//  BudgetError.swift
//  BudgetApp
//
//  Created by Andrei Motan on 20/10/24.
//

import Foundation

enum BudgetError: LocalizedError {
    case invalidBudgetId
    case errorCreating
    case errorLoading
    
    var errorDescription: String? {
        switch self {
        case .invalidBudgetId:
            return "Expense does not have a valid budget ID."
        case .errorCreating:
            return "Error creating an expense"
        case .errorLoading:
            return "Error loading expense"
        }
    }
}
