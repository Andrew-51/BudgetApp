//
//  Expense.swift
//  BudgetApp
//
//  Created by Andrei Motan on 20/10/24.
//

import Foundation

struct Expense: Codable, Identifiable {
    var id: Int?
    let name: String
    let amount: Double
    var createAt: Date?
    var budgetId: Int
    var receiptPath: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case amount = "amount"
        case createAt = "created_at"
        case budgetId = "budget_id"
        case receiptPath = "receipt_path"
    }
}
