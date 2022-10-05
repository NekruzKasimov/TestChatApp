//
//  AppNavigator.swift
//  TestChatApp
//
//  Created by Niko on 03.10.22.
//

import Foundation
import Resolver
import RxCocoa

struct AppNavigator {

    let window: UIWindow

    func start() -> Signal<Void> {
        let vc = Resolver.resolve(ITabbarViewController.self)
        self.window.rootViewController = UINavigationController(rootViewController: vc)
        self.window.makeKeyAndVisible()
        return .never()
    }
}
