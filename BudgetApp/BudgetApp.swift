//
//  BudgetAppApp.swift
//  BudgetApp
//
//  Created by Andrei Motan on 13/10/24.
//

import SwiftUI
import Supabase

@main
struct BudgetApp: App {
    
    @State private var router = Router()
    @State private var signInStatus: SignInStatus = .idle
    
    let authClient: AuthClient = .development
    let storageClient: SupabaseStorageClient = .development
    
    private enum SignInStatus {
        case idle
        case signedIn
        case signedOut
    }
    
    private func listenAuthEvents() async {
        
        for await (event, _) in authClient.authStateChanges {
            
            if case .initialSession = event {
               
                do {
                    let _ = try await authClient.session
                    signInStatus = .signedIn
                } catch let error as AuthError {
                    print(error)
                    signInStatus = .signedOut
                } catch {
                    signInStatus = .signedOut
                }
            }
            
            if case .signedIn = event {
                // take the user to budgets screen
                router.routes.append(.budgets)
                //signInStatus = .signedIn
            }
            
            if case .signedOut = event {
                // take the user to login screen
                router.routes = []
                signInStatus = .signedOut
            }
            
        }
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.routes) {
                
                Group {
                    switch signInStatus {
                        case .idle:
                            ProgressView("Loading...")
                        case .signedIn:
                            BudgetListScreen()
                        case .signedOut:
                            LoginScreen()
                    }
                }.navigationDestination(for: Route.self) { route in
                        switch route {
                            case .budgets:
                                BudgetListScreen()
                            case .login:
                                LoginScreen()
                        }
                    }
            }
            .environment(BudgetsTrackerStore(supabaseClient: .development))
            .environment(\.authClient, authClient)
            .environment(\.storageClient, storageClient)
            .environment(router)
            .task {
                await listenAuthEvents()
            }
        }
    }
}
