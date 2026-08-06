//
//  TaskModel.swift
//  Viora
//
//  Created by tascu nicoleta on 03/08/2026.
//

import Foundation
import SwiftData

@Model
final class TaskModel {
    var title: String
    var createdAt: Date
    var dueDate: Date
    var isCompleted: Bool
    
    init(title: String, dueDate: Date) {
        self.title = title
        self.createdAt = Date()
        self.dueDate = dueDate
        self.isCompleted = false
    }
}
