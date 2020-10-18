//
//  Card+CoreDataProperties.swift
//  Lemon
//
//  Created by Vsevolod Pavlovskyi on 17.10.2020.
//
//

import Foundation
import CoreData

extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var balance: Int64
    @NSManaged public var bank: String
    @NSManaged public var color: String
    @NSManaged public var currency: String
    @NSManaged public var id: Int64
    @NSManaged public var number: Int16
    @NSManaged public var type: String

}

extension Card : Identifiable {

}
