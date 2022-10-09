//
//  MainPageViewModel.swift
//  TestChatApp
//
//  Created by Niko on 03.10.22.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

protocol IMainPageViewModel {
    func transform(_ input: MainPageViewModel.Input) -> MainPageViewModel.Output
}

struct MainPageViewModel: IMainPageViewModel {
    var navigator: IMainPageNavigator
    var chatUseCase: IChatUseCase
    
    func transform(_ input: MainPageViewModel.Input) -> MainPageViewModel.Output {
        
        let dataStorageChats = BehaviorRelay(value: DataManager.sharedInstance.retreiveChats() ?? []).asSignal(onErrorJustReturn: [])
        
        let models = input
            .viewWillAppear
            .flatMapLatest {
                chatUseCase.chats().map { $0 }.asSignal(onErrorJustReturn: [])
            }
        
  
        let result = Signal<[ChatModel]>.combineLatest(dataStorageChats, models,  resultSelector: { dbChats, serverChats in
            if serverChats.isEmpty {
                return dbChats
            }
            return serverChats
        })
            .do(onNext: { chats in
                DataManager.sharedInstance.saveChats(chats)
            })
            .also { objects in
                input.itemSelected.flatMapLatest { indexPath -> Signal<Void> in
                    navigator.openChatPage(with: objects[indexPath.item])
                    return .never()
                }
            }.asSignal(onErrorJustReturn: [])
        
        return Output(chats: result)
    }
}

extension MainPageViewModel {
    
    struct Input {
        var viewWillAppear: Signal<Void>
        var itemSelected: Signal<IndexPath>
    }
    
    struct Output {
        var chats: Signal<[ChatModel]>
    }
}
