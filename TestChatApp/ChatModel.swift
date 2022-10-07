//
//  ChatModel.swift
//  TestChatApp
//
//  Created by Niko on 04.10.22.
//

import Foundation
import UIKit
import CoreData

struct ChatModel: Codable {
    var chatId: String
    var chatName: String
    var lastMessage: String
    var iconUrl: String?
    var messages: [MessageModel] = []
    
    func toChatEntity() -> ChatEntity {
        var messageEntity = [MessageEntity]()
        messages.forEach { messageEntity.append($0.toMessageEntity()) }
        
        return ChatEntity(chatId: chatId, chatName: chatName, lastMessage: lastMessage, iconUrl: iconUrl, messages: messageEntity)
    }
}


@objc(ChatEntity)
class ChatEntity: NSManagedObject {
    @NSManaged public var chatId : String
    @NSManaged public var chatName: String
    @NSManaged public var lastMessage: String
    @NSManaged public var iconUrl: String?
    @NSManaged public var messages: NSOrderedSet

    init(chatId: String, chatName: String, lastMessage: String, iconUrl: String?, messages: [MessageEntity]) {
        self.init()
        self.chatId = chatId
        self.chatName = chatName
        self.lastMessage = lastMessage
        self.iconUrl = iconUrl
        for (index, item) in messages.enumerated() {
            insertIntoMessages(item, at: index)
        }
    }

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)

    }

    func toChatModel() -> ChatModel {
        var messageModels = [MessageModel]()
        messages.forEach { messageModels.append(($0 as! MessageEntity).toMessageModel())}

        return ChatModel(chatId: chatId, chatName: chatName, lastMessage: lastMessage, messages: messageModels)
    }
}

extension ChatEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatEntity> {
        return NSFetchRequest<ChatEntity>(entityName: "ChatEntity")
    }
}

// MARK: Generated accessors for messages
extension ChatEntity {

    @objc(insertObject:inMessagesAtIndex:)
    @NSManaged public func insertIntoMessages(_ value: MessageEntity, at idx: Int)

    @objc(removeObjectFromMessagesAtIndex:)
    @NSManaged public func removeFromMessages(at idx: Int)

    @objc(insertMessages:atIndexes:)
    @NSManaged public func insertIntoMessages(_ values: [MessageEntity], at indexes: NSIndexSet)

    @objc(removeMessagesAtIndexes:)
    @NSManaged public func removeFromMessages(at indexes: NSIndexSet)

    @objc(replaceObjectInMessagesAtIndex:withObject:)
    @NSManaged public func replaceMessages(at idx: Int, with value: MessageEntity)

    @objc(replaceMessagesAtIndexes:withMessages:)
    @NSManaged public func replaceMessages(at indexes: NSIndexSet, with values: [MessageEntity])

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: MessageEntity)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: MessageEntity)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSOrderedSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSOrderedSet)

}
