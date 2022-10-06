//
//  ChatViewModel.swift
//  TestChatApp
//
//  Created by Niko on 06.10.22.
//

import Foundation
import MessageKit

protocol IChatViewModel {
    func chatTitle() -> String
    func messages() -> [MessageType]
}

struct ChatViewModel: IChatViewModel {
    
    var navigator: IChatNavigator
    var chat: ChatModel
    
    func chatTitle() -> String {
        return chat.chatName
    }
    
    func messages() -> [MessageType] {
        return chat.messages.map { $0.toMessageType() }
    }
}
