//
//  ChatNavigator.swift
//  TestChatApp
//
//  Created by Niko on 06.10.22.
//

import Foundation

protocol IChatNavigator {
    
}


struct ChatNavigator: IChatNavigator {
    weak var viewController: IChatViewController!
}
