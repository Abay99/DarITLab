//
//  Message+CoreDataProperties.swift
//  ForteBankMessanger
//
//  Created by Abai Kalikov on 4/4/19.
//  Copyright © 2019 Abai Kalikov. All rights reserved.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var isSender: Bool
    @NSManaged public var message: String?
    @NSManaged public var contact: Contact?

}
