//
//  StorageClientKey.swift
//  BudgetApp
//
//  Created by Andrei Motan on 17/11/24.
//

import Foundation
import SwiftUI
import Supabase

struct StorageKey: EnvironmentKey {
    static let defaultValue: SupabaseStorageClient = SupabaseClient.development.storage
}

extension EnvironmentValues {
    public var storageClient: SupabaseStorageClient {
        get { self[StorageKey.self] }
        set { self[StorageKey.self] = newValue }
    }
}
