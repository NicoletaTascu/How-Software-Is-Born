# Lecția 4 – Partea 1

# Ziua în care protocolul meu a încetat să-și mai cunoască implementarea

Când am început să construiesc `DatabaseProtocol`, eram convinsă că este suficient de abstract.

Toate operațiile CRUD erau generice.

`fetchAll`.

`fetch`.

`insert`.

`delete`.

Totul părea independent de implementarea concretă.

Sau cel puțin așa credeam.

---

## Privind în urmă

Prima versiune a protocolului arăta astfel:

```swift
protocol DatabaseProtocol: Sendable {

    func performCriticalTransaction<T: Sendable>(
        _ transaction: (isolated DatabaseService) async throws -> T
    ) async throws -> T
}
```

La momentul respectiv nu vedeam nicio problemă.

Protocolul descria exact operațiile de care aveam nevoie, iar `Sendable` exprima faptul că implementările sunt sigure pentru utilizarea în contextul Swift Concurrency.

Eram mulțumită de această soluție.

Până când am început să citesc mai mult despre actori și izolare.

---

## O fisură pe care nu o observasem

Pe măsură ce aprofundam conceptele din Swift Structured Concurrency, am recitit protocolul.

De data aceasta, nu mă mai uitam dacă funcționează.

Încercam să înțeleg dacă exprimă corect intenția.

Atunci am observat ceva ce îmi scăpase complet.

O singură metodă făcea referire la un tip concret.

```swift
isolated DatabaseService
```

Restul protocolului era generic.

Această metodă nu.

Și atunci am realizat ceva important.

Protocolul meu încă știa cine îl implementează.

Nu era o abstracție completă.

---

## Două modificări aparent mici

Versiunea actuală arată astfel:

```swift
protocol DatabaseProtocol: Actor {

    func performCriticalTransaction<T: Sendable>(
        _ transaction: (isolated Self) async throws -> T
    ) async throws -> T
}
```

La prima vedere, sunt doar două modificări.

```swift
Sendable
```

a devenit

```swift
Actor
```

iar

```swift
isolated DatabaseService
```

a devenit

```swift
isolated Self
```

Prima schimbare transmite o intenție arhitecturală mai clară.

Orice tip care conformează la protocol trebuie să fie un actor.

Cum actorii sunt deja `Sendable`, nu pierd nimic prin această modificare.

Din contră.

Protocolul exprimă acum explicit faptul că izolare actorului face parte din design.

Dar adevărata schimbare este cea de-a doua.

---

## Momentul în care protocolul a devenit cu adevărat o abstracție

`Self` nu înseamnă `DatabaseService`.

În interiorul unui protocol, `Self` înseamnă „tipul care conformează protocolului”.

Astăzi este `DatabaseService`.

Mâine poate fi:

```swift
actor MockDatabaseService: DatabaseProtocol
```

Fără nicio modificare în protocol.

`isolated Self` devine automat

```swift
isolated MockDatabaseService
```

În acel moment am înțeles diferența dintre un protocol și o abstracție.

Un protocol poate descrie un set de funcționalități.

O abstracție merge un pas mai departe.

Nu știe cine o implementează.

---

## Ce am învățat

Dacă aș fi privit doar rezultatul final, probabil aș fi spus că am schimbat două linii de cod.

Astăzi cred că s-a schimbat mult mai mult.

S-a schimbat felul în care privesc protocoalele.

Nu mă mai întreb doar:

> „Pot defini operațiile de care am nevoie?”

Mă întreb și:

> „Protocolul meu este cu adevărat independent de implementarea concretă?”

Pentru mine, aceasta este adevărata lecție a acestui refactoring.

---

## Mai departe...

Credeam că acesta va fi cel mai important refactoring din `DatabaseService`.

M-am înșelat.

În timp ce analizam metoda `performCriticalTransaction`, am descoperit o altă problemă.

De data aceasta nu mai era despre abstracție.

Era despre responsabilitatea funcției și despre garanțiile pe care aceasta ar trebui să le ofere.

Aceasta este povestea din partea a doua.

🇬🇧 [Read this lesson in English](./lesson-4-part-1-en.md)
