//
//  MessageModel.swift
//  TestChatApp
//
//  Created by Niko on 05.10.22.
//

import Foundation
import MessageKit
import CoreData

struct MessageModel: Codable {
    var messageId: String
    var messageText: String
    var senderId: String
    var displayName: String
    
    func toMessageType() -> MessageType {
        let sender = Sender(senderId: senderId, displayName: displayName)
        return Message(sender: sender, messageId: messageId, sentDate: Date.now, text: messageText)
    }
    
    func toMessageEntity() -> MessageEntity {
        return MessageEntity(messageId: messageId, messageText: messageText, senderId: senderId, displayName: displayName)
    }
}

struct Message: MessageType {
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
    
    init(sender: Sender, messageId: String, sentDate: Date, text: String) {
        self.sender = sender
        self.messageId = messageId
        self.sentDate = sentDate
        self.kind = .text(text)
    }
}

struct Sender: SenderType {
    var senderId: String
    public let displayName: String
}

@objc(MessageEntity)
class MessageEntity: NSManagedObject {
    @NSManaged public var displayName: String?
    @NSManaged public var messageId: String?
    @NSManaged public var messageText: String?
    @NSManaged public var senderId: String?
    @NSManaged public var chat: ChatEntity?

    init(messageId: String, messageText: String, senderId: String, displayName: String) {
        self.init()
        self.messageId = messageId
        self.messageText = messageText
        self.senderId = senderId
        self.displayName = displayName
    }

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    func toMessageModel() -> MessageModel {
        return MessageModel(messageId: messageId!, messageText: messageText!, senderId: senderId!, displayName: displayName!)
    }
}

extension MessageEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageEntity> {
        return NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
    }
}
