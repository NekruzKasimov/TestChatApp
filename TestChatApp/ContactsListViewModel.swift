//
//  ContactsListViewModel.swift
//  TestChatApp
//
//  Created by Niko on 04.10.22.
//

import Foundation
import RxCocoa
import RxSwift
import ContactsUI

protocol IContactsListViewModel {
    func transform(_ input: ContactsListViewModel.Input) -> ContactsListViewModel.Output
}

struct ContactsListViewModel: IContactsListViewModel {
    var navigator: IContactsListNavigator
    
    func transform(_ input: ContactsListViewModel.Input) -> ContactsListViewModel.Output {
        let models = input
            .viewWillAppear
            .flatMapLatest {
                PhoneContacts.getContacts().map { contacts in
                    var contactsModel: [ContactModel] = []
                    for item in contacts {
                        contactsModel.append(ContactModel(name: item.givenName))
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

class PhoneContacts {

    class func getContacts() -> Signal<[CNContact]> {

        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactThumbnailImageDataKey] as [Any]

        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print(R.string.localizable.contactsListErrorMessage())
        }

        let results = BehaviorRelay<[CNContact]>(value: [])

        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.accept(containerResults)
            } catch {
                print(R.string.localizable.contactsListErrorMessage())
            }
        }
        return results.asSignal(onErrorJustReturn: [])
    }
}