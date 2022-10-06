//
//  MainPageNavigator.swift
//  TestChatApp
//
//  Created by Niko on 03.10.22.
//

import Foundation
import Resolver

protocol IMainPageNavigator {
    func openChatPage(with chat: ChatModel)
}

struct MainPageNavigator: IMainPageNavigator {
    weak var viewController: IMainPageViewController!
    
    func openChatPage(with chat: ChatModel) {
        
    }
}
