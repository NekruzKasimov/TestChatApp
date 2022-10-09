//
//  DataManager.swift
//  TestChatApp
//
//  Created by Niko on 06.10.22.
//

import Foundation
import CoreData
import UIKit

open class DataManager: NSObject {
    public static let sharedInstance = DataManager()

    private override init() {}

    // Helper func for getting the current context.
    private func getContainer() -> NSPersistentCloudKitContainer? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer
    }

    func retreiveChats() -> [ChatModel]? {
        guard let managedContext = getContainer()?.viewContext else { return nil }
        let fetchEntity = NSFetchRequest<NSFetchRequestResult>(entityName: "ChatCD")
        
        do {
            let entities = try managedContext.fetch(fetchEntity)
            
            var result = [ChatModel]()
            for item in entities {
                if let item = item as? ChatCD {
                    result.append(item.toChatModel())
                }
            }
        } catch let error as NSError {
            print("Retrieving user failed. \(error): \(error.userInfo)")
        }
        return nil
    }

    func saveChats(_ chats: [ChatModel]) {
        guard let managedContext = getContainer()?.viewContext else { return }

        clearDatabase()

        managedContext.performAndWait {
            chats.forEach { chat in
                let chatEntity = ChatCD(context: managedContext)
                chatEntity.lastMessage = chat.lastMessage
                chatEntity.chatId = chat.chatId
                chatEntity.iconUrl = chat.iconUrl
                chatEntity.chatName = chat.chatName
                
                chat.messages.forEach { message in
                    let messageEntity = MessageCD(context: managedContext)
                    messageEntity.displayName = message.displayName
                    messageEntity.senderId = message.senderId
                    messageEntity.messageText = message.messageText
                    messageEntity.messageId = message.messageId
                    messageEntity.chat = chatEntity
                }
            }
        }
        
        if managedContext.hasChanges {
            try? managedContext.save()
        }
    }

    private func clearDatabase() {
        guard let container = getContainer()  else { return }
        let context = container.viewContext
        let persistenceCoordinator = container.persistentStoreCoordinator

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChatCD")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        _ = try? persistenceCoordinator.execute(deleteRequest, with: context)
    }
}
