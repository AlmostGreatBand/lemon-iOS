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

