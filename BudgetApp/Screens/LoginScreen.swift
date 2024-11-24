//
//  LoginScreen.swift
//  BudgetApp
//
//  Created by Andrei Motan on 17/11/24.
//

import SwiftUI
import Auth

struct LoginScreen: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isRegisterPresented: Bool = false
    
    @Environment(\.authClient) private var authClient
    
    private var isFormValid: Bool {
        !password.isEmptyOrWhiteSpace && email.isEmail
    }
    
    private func login() async {
        do {
            try await authClient.signIn(email: email, password: password)
            print("Login Success!")
        }
        catch let error as Auth.AuthError {
            switch error {
                case .api(let message, _, _, _):
                    self.errorMessage = message
                default:
                    self.errorMessage = "Authentication Error \(error)"
            }
        }
        catch {
            self.errorMessage = "Authentication failed."
        }
    }
    
    var body: some View {
        Form {
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
            HStack {
                Button("Login") {
                    Task {
                        await login()
                    }
                }.disabled(!isFormValid)
                Spacer()
                Button("Register") {
                    isRegisterPresented = true
                }
            }.buttonStyle(.borderless)
           
            
            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.errorMessage = ""
                        }
                    }
                    
            }
        }
        .navigationTitle("Login")
        .sheet(isPresented: $isRegisterPresented, content: {
            NavigationStack {
                RegisterScreen()
            }
        })
    }
}

#Preview {
    LoginScreen()
        .environment(\.authClient, .development)
}
