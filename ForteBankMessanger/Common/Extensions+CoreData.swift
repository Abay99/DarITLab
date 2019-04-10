//
//  Extensions+CoreData.swift
//  ForteBankMessanger
//
//  Created by Abai Kalikov on 4/9/19.
//  Copyright © 2019 Abai Kalikov. All rights reserved.
//

import UIKit
import CoreData

extension MainMessagesViewController {
    
    func clearData() {
        
        let context = PersistenceService.persistentContainer.viewContext
        
            do {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                    
                    let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]
                    
                    for object in objects! {
                        context.delete(object)
                    }
                try(context.save())
            } catch let err {
                print(err)
            }
    }
    
    func setupData() {
        
        clearData()
        
        let context = PersistenceService.persistentContainer.viewContext
        
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.message = "Hi, how are you?"
        message.date = NSDate()
        
        createJamesMessagesWithContext(context: context)
        
        _ = MainMessagesViewController.createMessageWithText(text: "Good morning. Wow! It’s wonderful to be chatting with the best iOS developer in the known world.", minutesAgo: 5, context: context)
        
        _ = MainMessagesViewController.createMessageWithText(text: "Nick, I'm being sinceriously now.", minutesAgo: 60 * 24, context: context)
        
        _ = MainMessagesViewController.createMessageWithText(text: "I smell something burning...", minutesAgo: 8 * 60 * 24, context: context)
        
        do {
            try(context.save())
        } catch let err {
            print(err)
        }
    }
    
    private func createJamesMessagesWithContext(context: NSManagedObjectContext) {
        
        _ = MainMessagesViewController.createMessageWithText(text: "Good morning...", minutesAgo: 3, context: context)
        _ = MainMessagesViewController.createMessageWithText(text: "Hello, how are you? I hope you're having a fine day.", minutesAgo: 2, context: context)
        _ = MainMessagesViewController.createMessageWithText(text: "Just finished GOTGV2! I put three years of blood, sweat and tears into this movie to make it awesome! You're going to love Baby Groot's dialogue.", minutesAgo: 1, context: context)
        _ = MainMessagesViewController.createMessageWithText(text: "Have you seen the movie?", minutesAgo: 1, context: context)
        _ = MainMessagesViewController.createMessageWithText(text: "Yes! I have seen Guardians Vol 2. It was awesome.", minutesAgo: 1, context: context, isSender: true)
        _ = MainMessagesViewController.createMessageWithText(text: "What was your favorite segment of the film?", minutesAgo: 1, context: context)
        _ = MainMessagesViewController.createMessageWithText(text: "Peter and Yondu's dialogue at the end. ''I'm Mary Poppins yall!'', was my favorite line. 😂", minutesAgo: 1, context: context, isSender: true)
        
    }
    
    static func createMessageWithText(text: String, minutesAgo: Double, context: NSManagedObjectContext, isSender: Bool = false) -> Message {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.message = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
        message.isSender = isSender
        
        return message
    }
}
