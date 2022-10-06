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
        let models = input
            .viewWillAppear
            .flatMapLatest {
                chatUseCase.chats().asSignal(onErrorJustReturn: [])
            }
        let result = models
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
