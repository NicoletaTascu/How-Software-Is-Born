# Lecția 4 –Evoluție

Primele două părți ale lecției au fost despre procesul de gândire din spatele celor două refactoringuri.

Acest document este diferit.

Nu spune povestea.

Prezintă evoluția designului și motivele tehnice care au dus la forma actuală a implementării.

---

# 1. DatabaseProtocol

## Înainte

```swift
protocol DatabaseProtocol: Sendable {

    func performCriticalTransaction<T: Sendable>(
        _ transaction: (isolated DatabaseService) async throws -> T
    ) async throws -> T
}
```

## Acum

```swift
protocol DatabaseProtocol: Actor {

    func performCriticalTransaction<T: Sendable>(
        _ transaction: (isolated Self) async throws -> T
    ) async throws -> T
}
```

La prima vedere pare o modificare minoră.

În realitate, cele două schimbări sunt strâns legate și definesc mai bine responsabilitatea protocolului.

---

## `Sendable` → `Actor`

Inițial, protocolul conforma la `Sendable`.

Acest lucru garanta că implementările sunt sigure pentru utilizarea în contextul Swift Concurrency.

Totuși, intenția proiectului era mai puternică.

Nu aveam nevoie doar de un tip sigur pentru concurență.

Aveam nevoie ca orice implementare să fie un actor.

Prin schimbarea conformării la `Actor`, această intenție devine parte din contractul protocolului.

În plus, nu se pierde nimic.

Orice actor conformează deja automat la `Sendable`.

Prin urmare, protocolul exprimă acum o garanție mai puternică folosind un concept mai specific.

---

## `isolated DatabaseService` → `isolated Self`

Aceasta este modificarea care schimbă cu adevărat nivelul de abstractizare.

În prima versiune, protocolul făcea referire directă la implementarea concretă.

```swift
isolated DatabaseService
```

Din acest motiv, metoda nu putea fi reutilizată natural de o altă implementare.

În interiorul unui protocol, `Self` reprezintă tipul concret care conformează protocolului.

Astfel,

```swift
actor MockDatabaseService: DatabaseProtocol
```

va transforma automat

```swift
isolated Self
```

în

```swift
isolated MockDatabaseService
```

fără nicio modificare suplimentară.

Protocolul nu mai cunoaște implementarea.

Descrie doar comportamentul pe care îl așteaptă.

---

## De ce contează această schimbare?

Înainte de acest refactoring, aproape întregul protocol era deja generic.

Metodele:

- `fetchAll`
- `fetch`
- `insert`
- `delete`

nu făceau referire la niciun tip concret.

Singura excepție era `performCriticalTransaction`.

Această metodă "trăda" implementarea.

Prin înlocuirea lui `DatabaseService` cu `Self`, întregul protocol devine consecvent.

---

# 2. DatabaseService

## `modelExecutor` devine `nonisolated`

În implementarea inițială aveam:

```swift
public let modelExecutor: any ModelExecutor
```

Ulterior a devenit:

```swift
nonisolated public let modelExecutor: any ModelExecutor
```

Protocolul `ModelActor` din SwiftData cere ca această proprietate să fie accesibilă fără izolare de actor.

Infrastructura SwiftData trebuie să poată accesa direct executorul fără a traversa granița actorului.

Adăugarea lui `nonisolated` exprimă explicit această intenție și respectă complet contractul impus de `ModelActor`.

---

## Refactoringul lui `performCriticalTransaction`

### Înainte

```swift
let result = try await transaction(self)

try await Task {

    try modelContext.save()

}.value
```

În această variantă, doar operația de `save()` era executată în interiorul noului `Task`.

Logica tranzacției rămânea în afara acelui context.

---

### Acum

```swift
try await Task {

    let result = try await transaction(self)

    try modelContext.save()

    return result

}.value
```

Acum întreaga tranzacție este executată în interiorul aceluiași context.

Nu doar salvarea finală.

Acest lucru reflectă mult mai bine responsabilitatea metodei.

---

## De ce contează această modificare?

Inițial mă concentram asupra operației de `save()`.

După acest refactoring am început să privesc întreaga tranzacție ca pe o singură operație logică.

Nu voiam să protejez doar ultimul pas.

Voiam ca toate operațiile executate în interiorul tranzacției să beneficieze de același context de execuție.

Această perspectivă a schimbat complet implementarea.

---

## Un detaliu interesant despre izolarea actorilor

Mutarea întregului cod în interiorul lui `Task { }` ridică o întrebare firească.

De ce funcționează fără apeluri suplimentare către actor?

Motivul este că acel `Task` este creat direct dintr-un context deja izolat pe actorul curent.

Closure-ul moștenește această izolare și poate accesa în mod direct atât:

```swift
transaction(self)
```

cât și

```swift
modelContext.save()
```

fără a fi nevoie de apeluri suplimentare către actor.

Înainte probabil aș fi acceptat acest comportament fără să mă întreb de ce.

Astăzi îmi place să înțeleg și mecanismul din spatele lui.

---

# Ce NU s-a schimbat

Uneori un refactoring important nu înseamnă rescrierea întregii implementări.

Metodele:

- `fetchAll`
- `fetch`
- `insert`
- `delete`

au rămas neschimbate.

Erau deja suficient de generice și exprimau corect responsabilitatea lor.

Cele mai importante îmbunătățiri au fost făcute exact în locurile în care designul încă lăsa să se vadă implementarea concretă sau nu exprima suficient de clar intenția codului.

---

# Concluzie

Privind în urmă, observ că implementarea nu s-a schimbat radical.

Nici arhitectura.

S-au schimbat însă întrebările pe care mi le pun atunci când proiectez un API.

La început mă întrebam:

> **„Funcționează?”**

Astăzi mă întreb:

> **„Exprimă această implementare garanțiile pe care vreau să le ofere?”**

Cred că aceasta este cea mai importantă schimbare din această lecție.

Nu este despre `DatabaseProtocol`.

Nu este despre `Task`.

Nu este despre `Actor`.

Este despre felul în care încep să privesc designul unui API.

🇬🇧 [Read this lesson in English](./lesson-4-evolution-en.md)
