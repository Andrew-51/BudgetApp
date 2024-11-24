//
//  ExpenseError.swift
//  BudgetApp
//
//  Created by Andrei Motan on 17/11/24.
//

import Foundation

enum ExpenseError: LocalizedError {
    
    case invalidExpenseId
    
    var errorDescription: String? {
        switch self {
            case .invalidExpenseId:
                return "Expense does not have a valid ID."
        }
    }
    
}
