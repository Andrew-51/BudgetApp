//
//  SupabaseStorageClient+extensions.swift
//  BudgetApp
//
//  Created by Andrei Motan on 17/11/24.
//

import Foundation
import Supabase

extension SupabaseStorageClient {
    static var development: SupabaseStorageClient {
        SupabaseClient.development.storage
    }
}
