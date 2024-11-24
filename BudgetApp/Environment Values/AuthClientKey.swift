//
//  AuthClientKey.swift
//  BudgetApp
//
//  Created by Andrei Motan on 17/11/24.
//

import Foundation
import SwiftUI
import Supabase

struct AuthClientKey: EnvironmentKey {
    static let defaultValue: AuthClient = SupabaseClient.development.auth
}

extension EnvironmentValues {
    public var authClient: AuthClient {
        get {self[AuthClientKey.self]}
        set {self[AuthClientKey.self] = newValue}
    }
}
