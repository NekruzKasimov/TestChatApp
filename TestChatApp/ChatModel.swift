//
//  ChatModel.swift
//  TestChatApp
//
//  Created by Niko on 04.10.22.
//

import Foundation
import UIKit

struct ChatModel: Codable {
    var chatId: Int
    var chatName: String
    var lastMessage: String
    var iconUrl: String?
    var messages: [MessageModel] = []
}
