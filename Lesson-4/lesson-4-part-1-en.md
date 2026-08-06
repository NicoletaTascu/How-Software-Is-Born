# Lesson 4 – Part 1

# The Day My Protocol Stopped Knowing Its Implementation

When I started building `DatabaseProtocol`, I was convinced it was already generic enough.

After all, every CRUD operation was generic.

`fetchAll`.

`fetch`.

`insert`.

`delete`.

Everything looked independent from the concrete implementation.

Or so I thought.

---

## Looking Back

My first version looked like this:

```swift
protocol DatabaseProtocol: Sendable {

    func performCriticalTransaction<T: Sendable>(
        _ transaction: (isolated DatabaseService) async throws -> T
    ) async throws -> T
}
```

At first glance, nothing seemed wrong.

The protocol described the operations I needed, and `Sendable` expressed that conforming types were safe to use with Swift Concurrency.

I was happy with it.

Until I wasn't.

---

## The Hidden Leak

While reviewing the code after learning more about actor isolation, I noticed something I had completely missed.

Only one method in the protocol referenced a concrete type.

```swift
isolated DatabaseService
```

Everything else was generic.

This one method wasn't.

That meant my abstraction wasn't complete.

The protocol still knew who implemented it.

That realization completely changed the way I looked at the design.

---

## Two Small Changes

The final version became:

```swift
protocol DatabaseProtocol: Actor {

    func performCriticalTransaction<T: Sendable>(
        _ transaction: (isolated Self) async throws -> T
    ) async throws -> T
}
```

Only two lines changed.

```swift
Sendable
```

became

```swift
Actor
```

and

```swift
isolated DatabaseService
```

became

```swift
isolated Self
```

The first change guarantees that every implementation of the protocol is an actor.

Since actors are already `Sendable`, nothing is lost, but the protocol now communicates a stronger architectural intention.

The second change was the one that really mattered.

`Self` doesn't refer to `DatabaseService`.

It refers to whichever actor conforms to the protocol.

For example, if I later create:

```swift
actor MockDatabaseService: DatabaseProtocol
```

then

```swift
isolated Self
```

automatically becomes

```swift
isolated MockDatabaseService
```

without changing the protocol.

That is what abstraction should feel like.

---

## What I Learned

Before this refactoring, I thought I had written a protocol.

After this refactoring, I realized I had finally written an abstraction.

The difference is subtle.

A protocol defines capabilities.

A good abstraction does something more.

It doesn't know who implements those capabilities.

That was the lesson hidden behind two seemingly insignificant lines of code.

---

## Looking Forward

This wasn't the end of the refactoring.

While reviewing `performCriticalTransaction`, I discovered another design issue.

This time, it wasn't about abstraction.

It was about intent.

That became the second refactoring.
