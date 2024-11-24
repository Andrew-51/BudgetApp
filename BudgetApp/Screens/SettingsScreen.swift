//
//  SettingsScreen.swift
//  BudgetApp
//
//  Created by Andrei Motan on 17/11/24.
//

import SwiftUI

struct SettingsScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.authClient) private var authClient
    
    var body: some View {
        Button("Sign Out") {
            Task {
                do {
                    try await authClient.signOut()
                    dismiss()
                } catch {
                    print(error)
                }
            }
        }
    }
}

#Preview {
    SettingsScreen()
        .environment(\.authClient, .development)
}
