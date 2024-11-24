//
//  String+Extension.swift
//  BudgetApp
//
//  Created by Andrei Motan on 17/11/24.
//

import Foundation

extension String {
    
    var isEmptyOrWhiteSpace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isEmail: Bool {
        
        guard !self.isEmptyOrWhiteSpace else { return false }
        
        // Define a simplified regular expression pattern for an email
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }
}
