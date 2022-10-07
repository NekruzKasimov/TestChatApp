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

        do {
            let chatEntities = try managedContext.fetch(ChatEntity.fetchRequest()) as! [ChatEntity]
            var result = [ChatModel]()

            for item in chatEntities {
                result.append(item.toChatModel())
            }
            
            return result
        } catch let error as NSError {
            print("Retrieving user failed. \(error): \(error.userInfo)")
            return nil
        }
    }

    func saveChats(_ chats: [ChatModel]) {
        guard let managedContext = getContainer()?.viewContext else { return }

        clearDatabase()

        chats.forEach { chat in
            let chatEntity = ChatEntity(context: managedContext)
            chatEntity.lastMessage = chat.lastMessage
            chatEntity.chatId = chat.chatId
            chatEntity.iconUrl = chat.iconUrl
            chatEntity.chatName = chat.chatName


            for (index, message) in chat.messages.enumerated() {
                let messageEntity = MessageEntity(context: managedContext)
                messageEntity.displayName = message.displayName
                messageEntity.senderId = message.senderId
                messageEntity.messageText = message.messageText
                messageEntity.messageId = message.messageId
                chatEntity.insertIntoMessages(messageEntity, at: index)
            }
            
           
            
            try? managedContext.save()
        }
    }

    private func clearDatabase() {
        guard let container = getContainer()  else { return }
        let context = container.viewContext
        let persistenceCoordinator = container.persistentStoreCoordinator

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChatEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        try? persistenceCoordinator.execute(deleteRequest, with: context)
    }

    private func saveMessages(managedContext: NSManagedObjectContext, messages: [MessageModel]) {
        messages.forEach { message in
            let newMessage = NSEntityDescription.insertNewObject(forEntityName: "MessageEntity", into: managedContext) as! MessageEntity
            newMessage.setValue(message.messageText, forKey: "messageText")
            newMessage.setValue(message.messageId, forKey: "messageId")
            newMessage.setValue(message.senderId, forKey: "senderId")
            newMessage.setValue(message.displayName, forKey: "displayName")
        }

        do {
            print("Saving session...")
            try managedContext.save()
        } catch let error as NSError {
            print("Failed to save session data! \(error): \(error.userInfo)")
        }
    }
}
