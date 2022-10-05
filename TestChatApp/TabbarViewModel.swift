//
//  TabbarViewModel.swift
//  TestChatApp
//
//  Created by Niko on 03.10.22.
//

import Foundation
import RxSwift
import RxCocoa

protocol ITabbarViewModel {
    func transform(_ input: TabbarViewModel.Input) -> TabbarViewModel.Output
}

struct TabbarViewModel: ITabbarViewModel {
    var navigator: ITabbarNavigator
    
    func transform(_ input: Input) -> Output {
        let result: Signal<Void> = input.addContacts.do(onNext: { navigator.openContactsListPage() })
        
        return Output(contactsOutput: result)
    }
    
}

extension TabbarViewModel {
    struct Input {
        var addContacts: Signal<Void>
    }
    
    struct Output {
        var contactsOutput: Signal<Void>
    }
}
