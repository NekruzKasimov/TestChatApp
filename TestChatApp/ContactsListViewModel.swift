//
//  ContactsListViewModel.swift
//  TestChatApp
//
//  Created by Niko on 04.10.22.
//

import Foundation
import RxCocoa
import RxSwift

protocol IContactsListViewModel {
    func transform(_ input: ContactsListViewModel.Input) -> ContactsListViewModel.Output
}

struct ContactsListViewModel: IContactsListViewModel {
    var navigator: IContactsListNavigator
    
    func transform(_ input: ContactsListViewModel.Input) -> ContactsListViewModel.Output {
        let models = input
            .viewWillAppear
            .flatMapLatest {
                PhoneContacts.getContacts().map { contacts -> [ContactModel]  in
                    var contactsModel: [ContactModel] = []
                    for item in contacts {
                        contactsModel.append(ContactModel(name: item.givenName, iconData: item.thumbnailImageData))
                    }
                    return contactsModel
                }
            }
        let result = models
            .also { objects in
                input.itemSelected.flatMapLatest { indexPath -> Signal<Void> in
                    navigator.openChatPage(with: objects[indexPath.item])
                    return .never()
                }
            }.asSignal(onErrorJustReturn: [])
        
        return Output(contacts: result)
    }
}

extension ContactsListViewModel {
    struct Input {
        var viewWillAppear: Signal<Void>
        var itemSelected: Signal<IndexPath>
    }
    
    struct Output {
        var contacts: Signal<[ContactModel]>
    }
}
