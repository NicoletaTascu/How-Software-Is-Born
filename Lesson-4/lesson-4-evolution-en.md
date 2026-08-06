# Lesson 4 – Design Evolution

The previous two parts focused on the reasoning behind the refactoring.

This document is different.

It summarizes the technical changes that transformed the first implementation into the current one.

Instead of telling the story, these notes explain the design decisions.

---

# 1. DatabaseProtocol

## Before

```swift
protocol DatabaseProtocol: Sendable {

    func performCriticalTransaction<T: Sendable>(
        _ transaction: (isolated DatabaseService) async throws -> T
    ) async throws -> T

}
```

## After

```swift
protocol DatabaseProtocol: Actor {

    func performCriticalTransaction<T: Sendable>(
        _ transaction: (isolated Self) async throws -> T
    ) async throws -> T

}
```

Only two lines changed, but they are closely related.

---

## Sendable → Actor

`Actor` is a special protocol in Swift.

Every actor automatically conforms to `Sendable`, so changing the protocol from `Sendable` to `Actor` doesn't remove any guarantees.

Instead, it adds a stronger one.

Every type conforming to `DatabaseProtocol` must now be an actor.

That makes the isolation boundary part of the protocol's design instead of something left to the implementation.

---

## isolated DatabaseService → isolated Self

This is the most important design improvement.

The original protocol referenced the concrete implementation.

```swift
isolated DatabaseService
```

That meant the protocol wasn't completely independent.

It still knew which type implemented it.

Replacing it with

```swift
isolated Self
```

changes the meaning completely.

Inside a protocol, `Self` always refers to the conforming type.

For example,

```swift
actor MockDatabaseService: DatabaseProtocol
```

automatically transforms

```swift
isolated Self
```

into

```swift
isolated MockDatabaseService
```

without requiring any changes to the protocol.

The protocol now describes behavior instead of a specific implementation.

---

## Why It Matters

Without this change, every implementation of
`performCriticalTransaction`
would still depend on the concrete
`DatabaseService`.

The rest of the protocol was already fully generic.

Only this single method leaked the implementation.

Removing that dependency completed the abstraction.

---

# 2. DatabaseService

## nonisolated modelExecutor

The original implementation contained

```swift
public let modelExecutor: any ModelExecutor
```

It became

```swift
nonisolated public let modelExecutor: any ModelExecutor
```

`ModelActor` requires `modelExecutor` to be accessible without actor isolation.

SwiftData infrastructure needs direct access to it without performing an actor hop.

Adding `nonisolated` makes that intention explicit and fully satisfies the requirements of `ModelActor`.

---

## Refactoring performCriticalTransaction

### Before

```swift
let result = try await transaction(self)

try await Task {

    try modelContext.save()

}.value
```

Only the final `save()` executed inside the new task.

The transaction itself still executed outside that execution boundary.

---

### After

```swift
try await Task {

    let result = try await transaction(self)

    try modelContext.save()

    return result

}.value
```

Now the entire operation executes inside the same task.

The transaction and the final save belong to the same execution boundary.

This better reflects the intention of a critical transaction.

---

## Why This Refactoring Matters

The goal wasn't simply to protect `save()`.

The goal was to protect the entire critical operation.

Thinking in terms of execution boundaries rather than individual statements made the implementation much clearer.

The code now expresses the same intention communicated by the method name.

---

## Actor Isolation

One interesting detail is why the refactored implementation still compiles without additional actor hops.

The closure passed to `Task {}` inherits the current actor isolation because it is created directly from an already isolated actor context.

That allows both

```swift
transaction(self)
```

and

```swift
modelContext.save()
```

to execute naturally inside the task without requiring additional `await self` calls.

Understanding this behavior helped me better understand actor isolation itself.

---

## What Didn't Change

Several parts of the service were already correctly designed.

The following methods remained unchanged:

- `fetchAll`
- `fetch`
- `insert`
- `delete`

They were already generic over `PersistentModel` and independent of any concrete implementation.

Not every refactoring requires rewriting an entire service.

Sometimes the most important improvements come from identifying a few places where the design leaks implementation details.

---

# Final Thoughts

Looking back, the implementation didn't change dramatically.

The architecture didn't change either.

What changed was the way I understand the code.

At first, I focused on making the implementation work.

After studying Swift Structured Concurrency more deeply, I started asking different questions.

Not only

> "Does it work?"

but also

> "Does the implementation express the guarantees I want this API to provide?"

That shift in perspective is, for me, the real lesson behind this refactoring.

🇷🇴 [Read this lesson in Romanian](./lesson-4-evolutie-ro.md)
