//
//  RegisterScreen.swift
//  BudgetApp
//
//  Created by Andrei Motan on 17/11/24.
//

import SwiftUI
import Auth

struct RegisterScreen: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    
    @Environment(\.authClient) private var authClient
    @Environment(\.dismiss) private var dismiss
    @State private var isSignedUp: Bool = false
    
    private var isFormValid: Bool {
        !password.isEmptyOrWhiteSpace && email.isEmail
    }
    
    private func register() async {
        
        do {
            let _ = try await authClient.signUp(email: email, password: password)
            isSignedUp = true
        }
        catch let error as Auth.AuthError {
            switch error {
                case .api(let message, _, _, _):
                    self.errorMessage = message
                default:
                    self.errorMessage = "Authentication Error \(error.message)"
            }
        }
        catch {
            self.errorMessage = "Authentication failed \(error)."
        }
        
    }
    
    var body: some View {
        Form {
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
            Button("Register") {
                Task {await register()}
            }.disabled(!isFormValid)
            
            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }
        }
        .alert("Your account has been created successfully", isPresented: $isSignedUp){
            Button("OK", role: .cancel) { dismiss() }
        }
        .navigationTitle("Register")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    RegisterScreen()
        .environment(\.authClient, .development)
}
