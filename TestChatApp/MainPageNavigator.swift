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
        let vc = Resolver.resolve(IChatViewController.self, args: ["chat": chat])
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}
