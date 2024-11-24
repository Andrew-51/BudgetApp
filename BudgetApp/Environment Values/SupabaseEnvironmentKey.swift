//
//  SupabaseEnvironmentKey.swift
//  BudgetApp
//
//  Created by Andrei Motan on 13/10/24.
//

import Foundation
import SwiftUI
import Supabase

struct SupabaseEnvironmentKey: EnvironmentKey {
    static let defaultValue: SupabaseClient = .development
}

extension EnvironmentValues {
    public var supabaseClient: SupabaseClient {
        get {self[SupabaseEnvironmentKey.self]}
        set {self[SupabaseEnvironmentKey.self] = newValue}
    }
}
