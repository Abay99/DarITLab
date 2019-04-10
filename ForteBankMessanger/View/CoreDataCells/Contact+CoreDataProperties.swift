//
//  Contact+CoreDataProperties.swift
//  ForteBankMessanger
//
//  Created by Abai Kalikov on 4/4/19.
//  Copyright © 2019 Abai Kalikov. All rights reserved.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var name: String?
    @NSManaged public var profileImage: String?
    @NSManaged public var lastMessage: Message?
    @NSManaged public var messages: Message?

}
