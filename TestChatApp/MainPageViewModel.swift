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
//    func transform(_ input: MainPageViewModel.Input) -> MainPageViewModel.Output
}

struct MainPageViewModel: IMainPageViewModel {
    var navigator: IMainPageNavigator
}
