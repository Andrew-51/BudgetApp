//
//  AddExpenseScreen.swift
//  BudgetApp
//
//  Created by Andrei Motan on 20/10/24.
//

import SwiftUI
import PhotosUI
import os

struct AddExpenseScreen: View {
    
    let budget: Budget
    
    @State private var name: String = ""
    @State private var amount: Double?
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var uiImage: UIImage?
    
    @Environment(\.dismiss) private var dismiss
    @Environment(BudgetsTrackerStore.self) private var budgetsStore
    
    private func saveExpense() async throws {
        guard let amount = amount,
              let budgetId = budget.id
        else { return }
        
        let expense = Expense(name: name, amount: amount, budgetId: budgetId)
        
        do {
            
            let budgetIdString = String(describing: expense.budgetId)
            print("AddExpenseScreen - saveExpense: \(String(describing: expense.budgetId))")
            print("AddExpenseScreen - saveExpense: \(budgetIdString)")
            
            try await budgetsStore.addExpense(expense)
            dismiss()
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        Form{
            TextField("Enter name", text: $name)
            
            TextField("Enter amount", value: $amount, format: .number)
            
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
            }
            
            HStack {
                PhotosPicker(selection: $selectedPhotoItem, matching: .images){
                    Text("Select a photo")
                }
            }
        }
        .onChange(of: selectedPhotoItem) {
            selectedPhotoItem?.loadTransferable(type: Data.self, completionHandler: { result in
                switch result {
                    case .success(let data):
                        if let data {
                            guard let img = UIImage(data: data) else { return }
                            uiImage = img
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                }
                    
            })
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    Task {
                        try await saveExpense()
                    }
                }
            }
        }
    }
}

/*#Preview {
    NavigationStack {
        AddExpenseScreen(budget: Budget(id: 9, name: "Test", limit: 122))
    }.environment(ExpensesTrackerStore(supabaseClient: .development, budgetsTrackerStore: <#BudgetsTrackerStore#>)).environment(BudgetsTrackerStore(supabaseClient: .development))
}*/

#Preview {
    let budgetsStore = BudgetsTrackerStore(supabaseClient: .development)
    //let expensesStore = ExpensesTrackerStore(supabaseClient: .development, budgetsTrackerStore: budgetsStore)

    NavigationStack {
        AddExpenseScreen(budget: Budget(id: 9, name: "Test", limit: 122, userId: UUID()))
            .environment(budgetsStore)      // Usa environmentObject
            //.environment(expensesStore)      // Usa environmentObject
    }
}
