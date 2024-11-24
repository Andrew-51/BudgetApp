//
//  AuthClient+Extensions.swift
//  BudgetApp
//
//  Created by Andrei Motan on 17/11/24.
//

import Foundation
import Supabase

extension AuthClient {
    static var development: AuthClient {
        SupabaseClient.development.auth
    }
}
