//
//  Items+CoreDataProperties.swift
//  Brokol
//
//  Created by Ammaar Khan on 26/11/2022.
//
//

import Foundation
import CoreData


extension Items {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Items> {
        return NSFetchRequest<Items>(entityName: "Items")
    }

    @NSManaged public var name: String?
    @NSManaged public var expiry: Date?

}

extension Items : Identifiable {

}
