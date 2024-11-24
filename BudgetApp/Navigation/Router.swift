//
//  Router.swift
//  BudgetApp
//
//  Created by Andrei Motan on 17/11/24.
//

import Foundation
import Observation

enum Route {
    case login
    case budgets
}

@Observable
class Router {
    var routes: [Route] = []
}
