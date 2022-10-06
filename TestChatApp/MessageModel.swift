//
//  MessageModel.swift
//  TestChatApp
//
//  Created by Niko on 05.10.22.
//

import Foundation
import MessageKit

struct MessageModel: Codable {
    let messageId: String
    let messageText: String
    let senderId: String
    let displayName: String
    
    func toMessageType() -> MessageType {
        let sender = Sender(senderId: senderId, displayName: displayName)
        return Message(sender: sender, messageId: messageId, sentDate: Date.now, text: messageText)
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
