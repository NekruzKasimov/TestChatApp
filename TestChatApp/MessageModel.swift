//
//  MessageModel.swift
//  TestChatApp
//
//  Created by Niko on 05.10.22.
//

import Foundation

struct MessageModel: Codable {
    let messageId: Int
    let messageText: String
    let isMine: Bool
}
