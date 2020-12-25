//
//  Transactions+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Vsevolod Pavlovskyi on 18.10.2020.
//
//

import Foundation
import CoreData


extension Transactions {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transactions> {
        return NSFetchRequest<Transactions>(entityName: "Transactions")
    }

    @NSManaged public var amount: Int64
    @NSManaged public var cardID: Int64
    @NSManaged public var date: Date
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var type: String
    
    var transactionType: TransactionType {
        set {
            type = newValue.rawValue
        }
        get {
            TransactionType(rawValue: type) ?? .shopping
        }
    }
}

extension Transactions : Identifiable {
    static func predicate(cardID: Int64?, with types: [TransactionType], searchText: String) -> NSPredicate? {
        var predicates = [NSPredicate]()

        if let id = cardID {
            predicates.append(NSPredicate(format: "cardID == %@", String(id)))
        }
        
        // 2
        if !types.isEmpty {
            let typesString = types.map { $0.rawValue }
            predicates.append(NSPredicate(format: "type IN %@", typesString))
        }

        // 3
        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "name CONTAINS[cd] %@", searchText.lowercased()))
        }

        // 4
        if predicates.isEmpty {
            return nil
        } else {
            return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
    }
}

enum TransactionType: String, CaseIterable {
    case donation = "Donation",
         entertainment = "Entertainment",
         food = "Food",
         health = "Health",
         shopping = "Shopping",
         transportation = "Transportation",
         utilities = "Utilities",
         income = "Income"
}

