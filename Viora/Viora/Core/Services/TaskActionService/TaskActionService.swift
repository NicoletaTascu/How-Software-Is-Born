//
//  TaskActionService.swift
//  Viora
//
//  Created by tascu nicoleta on 05/08/2026.
//

import Foundation
import SwiftData

struct TaskActionService: Sendable {
    private let database: DatabaseProtocol
    
    init(database: DatabaseProtocol) {
        self.database = database
    }
    
    func adaugăTaskNou(title: String, dueDate: Date, onSuccess: @escaping @MainActor () -> Void) {
        Task {
            do {
                    try await database.performCriticalTransaction { isolatedDb in
                    let newTask = TaskModel(title: title, dueDate: dueDate)
                    try await isolatedDb.insert(newTask) // Inserare izolată în fundal
                }
                await MainActor.run {
                    onSuccess()
                }
            } catch {
                print("Eroare la salvare: \(error.localizedDescription)")
            }
        }
    }
}
