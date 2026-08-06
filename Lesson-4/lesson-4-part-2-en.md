# Lesson 4 – Part 2

# The Second Refactoring – Protecting the Whole Transaction

After refactoring `DatabaseProtocol`, I thought the most important architectural change was behind me.

It wasn't.

While reviewing `performCriticalTransaction`, I noticed something much more subtle.

The implementation worked.

But it didn't express the intention behind the method.

---

## The Original Implementation

This was my initial implementation.

```swift
func performCriticalTransaction<T: Sendable>(
    _ transaction: (isolated DatabaseService) async throws -> T
) async throws -> T {

    do {

        let result = try await transaction(self)

        try await Task {

            try modelContext.save()

        }.value

        return result

    } catch {

        print("Error transaction DB: \(error)")
        throw error

    }
}
```

At the time, I believed I had already solved the cancellation problem.

The `save()` operation was executed inside a new `Task`, so I considered the critical part protected.

The implementation compiled.

The tests passed.

Everything looked fine.

Until I asked myself a different question.

---

## What Exactly Is the Critical Operation?

At first, my attention was focused on the last line.

```swift
try modelContext.save()
```

After reading more about Swift Structured Concurrency, I realized something important.

The critical operation wasn't the `save()`.

The critical operation was everything.

The transaction.

The changes.

The final save.

They all belong to the same logical unit of work.

Protecting only the final step meant protecting only the end of the operation.

Not the operation itself.

---

## The Refactoring

Instead of wrapping only the `save()`, I moved the entire transaction into the same execution boundary.

```swift
func performCriticalTransaction<T: Sendable>(
    _ transaction: (isolated DatabaseService) async throws -> T
) async throws -> T {

    try await Task {

        do {

            let result = try await transaction(self)

            try modelContext.save()

            return result

        } catch {

            print("performCriticalTransaction failed: \(error)")
            throw error

        }

    }.value
}
```

Interestingly, the amount of code barely changed.

The behavior did.

More importantly...

The intention became obvious.

---

## Thinking About the Function Differently

This refactoring changed the way I think about this method.

It isn't just another helper function.

It defines an execution context.

Whenever I call

```swift
performCriticalTransaction {

    ...

}
```

I'm not simply executing code.

I'm saying:

> "Everything inside this closure belongs to one critical operation."

That made me realize that `performCriticalTransaction` behaves very much like Swift's own `with...` functions.

Functions such as:

```swift
withTaskGroup { }
```

or

```swift
withThrowingTaskGroup { }
```

don't exist because they perform work themselves.

They exist because they create a context with well-defined guarantees.

I wanted `performCriticalTransaction` to express the same idea.

Not just *what* should happen.

But *under which guarantees* it should happen.

---

## A Small Detail That Matters

Another interesting discovery was understanding why this implementation still works without additional actor hops.

The closure passed to `Task { }` inherits the current actor isolation because it is created directly from an already isolated actor context.

That means both

```swift
transaction(self)
```

and

```swift
modelContext.save()
```

can execute naturally inside the task without requiring an additional `await self`.

Before studying actor isolation, I probably would have accepted this behavior without asking why.

Now I know the reason.

Understanding *why* something works has become just as important as making it work.

---

## What I Learned

This refactoring wasn't about moving code.

It was about making the implementation reflect the real responsibility of the function.

Before, I was asking:

> "How do I protect `save()`?"

Now I ask a different question.

> "What is the critical operation?"

The answer isn't the last line.

The answer is the entire transaction.

That single realization completely changed the implementation.

And, perhaps more importantly, it changed the way I think about designing APIs.

🇷🇴 [Read this lesson in Romanian](./lesson-4-part-2.md)
