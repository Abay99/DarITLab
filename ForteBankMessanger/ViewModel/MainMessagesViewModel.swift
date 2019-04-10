//
//  MainMessagesViewModel.swift
//  ForteBankMessanger
//
//  Created by Abai Kalikov on 3/22/19.
//  Copyright © 2019 Abai Kalikov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MainMessagesViewModel {
    
    var actions: [BasicAlertAction] = []
    var coreDataMessages: [Message] = []
    var messages: [MessageModel] = []
    
    init() {
        actions = [
            BasicAlertAction(title: "Camera", style: .default, icon: "Camera", switchViewController: CameraViewController()),
            BasicAlertAction(title: "Gallery", style: .default, icon: "Gallery", switchViewController: GalleryViewController())
        ]
        
//        let context = PersistenceService.persistentContainer.viewContext
//
//        do {
//            coreDataMessages = try context.fetch(Message.fetchRequest())
//        }
//        catch {
//            print(error)
//        }
//
//        for message in coreDataMessages {
//            messages.append(MessageModel(message: message.message!, isSender: message.isSender))
//        }
    
    }
    
//    func createMessageWithText(text: String, minutesAgo: Double, context: NSManagedObjectContext, isSender: Bool = false) -> Message {
//        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
////        message.contact = contact
//        message.message = text
//        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
//        message.isSender = isSender
//        
////        contact.lastMessage = message
//        
//        return message
//    }
}
