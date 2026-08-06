//
//  DashboardViewModel.swift
//  Viora
//
//  Created by tascu nicoleta on 01/08/2026.
//

import Foundation

@Observable
final class DashboardViewModel {
    private let database: DatabaseProtocol
    
    init(database: DatabaseProtocol) {
        self.database = database
    }
    
    var userName: String = "Nicoleta"
    
    var greeting: String.LocalizationValue {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12:  return "good_morning"
        case 12..<17: return "good_afternoon"
        default:      return "good_evening"
        }
    }
    var greetingWithName: String {
        String(
            localized: greeting) + ", \(userName) 👋"

    }
}
