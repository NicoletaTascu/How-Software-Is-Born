//
//  DatabaseProtocol.swift
//  Viora
//
//  Created by tascu nicoleta on 04/08/2026.
//

import Foundation
import SwiftData


/// Constrained to `Actor` (which already implies `Sendable`), so any
/// conforming type is guaranteed to provide its own isolation domain —
/// required for `isolated Self` in `performCriticalTransaction` below,
/// and it also means a test double must be an actor, not necessarily
/// `DatabaseService` itself.

protocol DatabaseProtocol: Actor {
    func fetchAll<M: PersistentModel>(sortBy descriptors: [SortDescriptor<M>]) async throws -> [M]
    func fetch<M: PersistentModel>(predicate: Predicate<M>?, sortBy descriptors: [SortDescriptor<M>]) async throws -> [M]
    func insert<M: PersistentModel>(_ model: M) async throws
    func delete<M: PersistentModel>(_ model: M) async throws
    
    
    /// `isolated Self` — not `isolated DatabaseService` — so the closure
    /// stays isolated to whichever conforming actor is calling this, not
    /// hard-coded to one concrete type. This is what makes the protocol
    /// substitutable for testing, consistent with every other requirement
    /// here.
    func performCriticalTransaction<T: Sendable>(
        _ transaction: @Sendable @escaping (isolated Self) async throws -> T
    ) async throws -> T
}
