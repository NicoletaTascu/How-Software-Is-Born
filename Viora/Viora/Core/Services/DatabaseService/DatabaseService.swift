//
//  DatabaseService.swift
//  Viora
//
//  Created by tascu nicoleta on 04/08/2026.
//

import Foundation
import SwiftData

actor DatabaseService: DatabaseProtocol, ModelActor {
    nonisolated public let modelContainer: ModelContainer
    public let modelExecutor: any ModelExecutor
    
    nonisolated public var modelContext: ModelContext {
        modelExecutor.modelContext
    }
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        let context = ModelContext(modelContainer)
        self.modelExecutor = DefaultSerialModelExecutor(modelContext: context)
    }
    
    // MARK: - Generic CRUD Operations
    
    func fetchAll<M: PersistentModel>(sortBy descriptors: [SortDescriptor<M>] = []) throws -> [M] {
        try modelContext.fetch(FetchDescriptor<M>(sortBy: descriptors))
    }
    
    func fetch<M: PersistentModel>(predicate: Predicate<M>?, sortBy descriptors: [SortDescriptor<M>] = []) throws -> [M] {
        let descriptor = FetchDescriptor<M>(predicate: predicate, sortBy: descriptors)
        return try modelContext.fetch(descriptor)
    }
    
    func insert<M: PersistentModel>(_ model: M) throws {
        modelContext.insert(model)
        try modelContext.save()
    }
    
    func delete<M: PersistentModel>(_ model: M) throws {
        modelContext.delete(model)
        try modelContext.save()
    }
    
    // MARK: - Generic Cancellation Shield
    func performCriticalTransaction<T: Sendable>(
        _ transaction: @Sendable @escaping (isolated DatabaseService) async throws -> T
    ) async throws -> T {
        let secureTask = Task {
            do {
                let result = try await transaction(self)
                
                print("Cancellation shield - saving in DB")
                try modelContext.save()
                
                return result
            } catch {
                print("Error transaction DB: \(error)")
                throw error
            }
        }
        return try await secureTask.value
    }
}
