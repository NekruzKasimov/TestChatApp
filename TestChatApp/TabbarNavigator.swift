//
//  TabbarNavigator.swift
//  TestChatApp
//
//  Created by Niko on 03.10.22.
//

import Foundation
import Resolver

protocol ITabbarNavigator {
    func openContactsListPage()
}

struct TabbarNavigator: ITabbarNavigator {
    weak var viewController: TabbarViewController!
    
    func openContactsListPage() {
        let vc = Resolver.resolve(IContactsListViewController.self)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}
