//
//  ContactsListNavigator.swift
//  TestChatApp
//
//  Created by Niko on 04.10.22.
//

import Foundation

protocol IContactsListNavigator {
    func openChatPage(with contact: ContactModel)
}

struct ContactsListNavigator: IContactsListNavigator {
    weak var viewController: IContactsListViewController!
    
    func openChatPage(with contact: ContactModel) {
        
    }
    
}
