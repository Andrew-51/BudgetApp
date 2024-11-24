//
//  BudgetModel.swift
//  BudgetApp
//
//  Created by Andrei Motan on 13/10/24.
//

import Foundation

struct Budget: Codable, Identifiable {
    var id: Int?
    let name: String
    let limit: Double
    var createAt: Date?
    //let isActive: Bool
    var expenses: [Expense]?
    var userId: UUID
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case limit = "limit"
        case createAt = "create_at"
        case userId = "user_id"
    }
}
