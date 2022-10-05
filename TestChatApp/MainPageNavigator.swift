//
//  MainPageNavigator.swift
//  TestChatApp
//
//  Created by Niko on 03.10.22.
//

import Foundation
import Resolver

protocol IMainPageNavigator {
}

struct MainPageNavigator: IMainPageNavigator {
    weak var viewController: IMainPageViewController!
}
