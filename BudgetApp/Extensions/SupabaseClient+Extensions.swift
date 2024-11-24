//
//  SupabaseClient+Extensions.swift
//  BudgetApp
//
//  Created by Andrei Motan on 13/10/24.
//

import Foundation
import Supabase

import Supabase

extension SupabaseClient {
    static var development: SupabaseClient {
        guard let supabaseURL = ProcessInfo.processInfo.environment["SUPABASE_URL"],
              let supabaseKey = ProcessInfo.processInfo.environment["SUPABASE_KEY"] else {
            fatalError("⚠️ Missing SUPABASE_URL or SUPABASE_KEY in environment variables")
        }
        return SupabaseClient(
            supabaseURL: URL(string: supabaseURL)!,
            supabaseKey: supabaseKey
        )
    }
}
