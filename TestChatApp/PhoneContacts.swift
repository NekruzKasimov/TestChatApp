//
//  PhoneContacts.swift
//  TestChatApp
//
//  Created by Niko on 05.10.22.
//

import Foundation
import ContactsUI
import RxCocoa
import RxSwift

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
