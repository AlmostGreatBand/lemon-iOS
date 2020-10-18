//
//  Persistence.swift
//  Lemon
//
//  Created by Vsevolod Pavlovskyi on 07.10.2020.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<50 {
//            let transaction = Transactions(context: viewContext)
//            
//            let type = TransactionType.allCases.randomElement()!
//            let lowerBound: Int64 = type == .income ? 0 : -10000000
//            let upperBound: Int64 = type == .income ? 10000000 : 0
//            
//            transaction.amount = Int64.random(in: lowerBound...upperBound)
//            transaction.cardID = Int64.random(in: 0...5)
//            transaction.date = Date(timeIntervalSinceNow: .random(in: -1000000...0))
//            transaction.id = UUID()
//            transaction.name = ""
//            transaction.type = type.rawValue
//            
//            if i <= 5 {
//                let banks = ["PrivatBank", "Monobank"]
//                let types = ["Gold", "Black", "Platinum", "Payments"]
//                let currencies = ["UAH", "USD", "RUB", "CAD", "BYN"]
//                
//                let card = Card(context: viewContext)
//                card.id = Int64(i)
//                card.bank = banks.randomElement() ?? "PrivatBank"
//                card.number = Int16.random(in: 0...9999)
//                card.type = types.randomElement() ?? "Gold"
//                card.balance = Int64(Int.random(in: 100...200000))
//                card.currency = currencies.randomElement() ?? "UAH"
//                card.color = cardColors.randomElement() ?? "Lime"
//            }
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Lemon")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
