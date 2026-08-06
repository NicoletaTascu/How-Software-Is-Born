//
//  AppContainer.swift
//  Viora
//
//  Created by tascu nicoleta on 04/08/2026.
//

import Foundation
import SwiftData

struct AppContainer {
    let databaseManager: DatabaseProtocol
    
    init(inMemory: Bool = false) {
        do {
            let schema = Schema([TaskModel.self])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)
            let container = try ModelContainer(for: schema, configurations: config)
            self.databaseManager = DatabaseService(modelContainer: container)
        } catch {
            fatalError("Eroare la inițializarea SwiftData: \(error)")
        }
    }
}
