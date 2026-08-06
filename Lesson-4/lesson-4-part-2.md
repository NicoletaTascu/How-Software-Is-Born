# Lecția 4 – Partea 2

# Al doilea refactoring – Protejând întreaga tranzacție

După ce am refactorizat `DatabaseProtocol`, am avut senzația că partea cea mai importantă a lecției se încheiase.

Protocolul devenise o abstracție adevărată.

Era timpul să merg mai departe.

Sau cel puțin așa credeam.

În timp ce reciteam implementarea lui `performCriticalTransaction`, am observat ceva ce îmi scăpase complet până atunci.

Codul funcționa.

Dar nu spunea aceeași poveste pe care o spunea numele funcției.

---

## Prima implementare

Inițial, metoda arăta astfel:

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

La momentul respectiv eram mulțumită.

Operația de `save()` era executată într-un `Task` nou și aveam impresia că exact partea critică a operației este protejată.

Codul compila.

Se comporta corect.

Nu aveam niciun motiv să-l schimb.

Până când am început să-mi pun o altă întrebare.

---

## Care este, de fapt, operația critică?

La început, atenția mea era concentrată asupra ultimei linii.

```swift
try modelContext.save()
```

După ce am aprofundat mai mult conceptele din Swift Structured Concurrency, am realizat că priveam problema prea îngust.

Operația critică nu era doar `save()`.

Operația critică era întreaga tranzacție.

Modificările asupra modelului.

Executarea logicii.

Salvarea finală.

Toate făceau parte din aceeași operație logică.

Dacă protejam doar ultima linie, însemna că protejam doar sfârșitul tranzacției.

Nu tranzacția în sine.

În acel moment am înțeles că implementarea și intenția metodei nu spuneau aceeași poveste.

---

## Refactoringul

Am mutat întregul bloc în interiorul aceluiași `Task`.

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

Privind diferența dintre cele două variante, modificarea pare aproape nesemnificativă.

Doar câteva linii au fost mutate.

În realitate însă, s-a schimbat modul în care funcția își exprimă responsabilitatea.

Acum întreaga tranzacție este executată în același context.

Nu doar ultima operație.

---

## O funcție care creează un context

În timpul acestui refactoring am realizat ceva ce nu observasem până atunci.

`performCriticalTransaction` nu este doar o funcție care execută cod.

Este o funcție care definește un context.

Ori de câte ori scriu:

```swift
performCriticalTransaction {

    ...

}
```

nu spun doar:

> „Execută acest cod.”

Spun ceva mult mai important.

> „Tot ceea ce se află în această închidere reprezintă o singură operație critică și trebuie tratat ca un întreg.”

În acel moment mi-am dat seama că această metodă seamănă foarte mult cu funcțiile de tip *with...* din Swift.

De exemplu:

```swift
withTaskGroup { }
```

sau

```swift
withThrowingTaskGroup { }
```

Aceste funcții nu există doar pentru a executa cod.

Ele creează un context și oferă anumite garanții.

Mi-am dorit ca și `performCriticalTransaction` să exprime aceeași idee.

Nu doar *ce* trebuie executat.

Ci și *în ce condiții* trebuie executat.

---

## Un detaliu pe care înainte l-aș fi ignorat

În timpul acestui refactoring am înțeles și de ce implementarea continuă să funcționeze fără apeluri suplimentare către actor.

Closure-ul transmis lui `Task { }` moștenește izolarea actorului curent deoarece este creat direct dintr-un context deja izolat.

Din acest motiv pot apela natural atât

```swift
transaction(self)
```

cât și

```swift
modelContext.save()
```

fără să fie nevoie de un nou `await self`.

Cu câteva săptămâni în urmă probabil aș fi acceptat acest comportament fără să mă întreb de ce funcționează.

Astăzi îmi place să înțeleg și mecanismul din spatele lui.

---

## Ce am învățat

La început credeam că acest refactoring este despre mutarea unor linii de cod.

Astăzi cred că este despre cu totul altceva.

Este despre intenție.

Înainte mă întrebam:

> „Cum protejez operația de `save()`?”

Acum mă întreb:

> „Care este, de fapt, operația critică?”

Răspunsul nu este ultima linie din funcție.

Răspunsul este întreaga tranzacție.

Iar în momentul în care am înțeles acest lucru, implementarea aproape că s-a scris singură.

---

## Mai departe...

După aceste două refactoringuri, implementarea ajunsese într-o formă care mă reprezenta.

Totuși, am simțit nevoia să notez și motivele tehnice din spatele fiecărei modificări.

Nu pentru că aș fi vrut să justific codul.

Ci pentru că nu voiam să uit procesul care m-a adus până aici.

În ultima parte a lecției am adunat aceste observații într-un document pe care l-am numit **Design Evolution**.

🇬🇧 [Read this lesson in English](./lesson-4-part-2-en.md)
