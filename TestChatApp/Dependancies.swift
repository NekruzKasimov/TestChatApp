//
//  Dependancies.swift
//  TestChatApp
//
//  Created by Niko on 03.10.22.
//

import Foundation
import Resolver

struct Config {
    static let baseUrl = URL(string: "https://giddymotion.backendless.app")!
}

extension Resolver.Name {
    static let mainWindow = Self(R.string.localizable.dependanciesMainWindowTitle())
    
    static let baseUrl = Self("baseUrl")
}

extension Resolver: ResolverRegistering {
    
    public static func registerAllServices() {
        registerScreens()
    }
    
    private static func registerScreens() {
        register(name: .mainWindow) { UIWindow() }.scope(.application)
        
        register { AppNavigator(window: $0.resolve(name: .mainWindow)) }
        
        register(name: .baseUrl) { Config.baseUrl }
        
        registerTabbarPage()
        registerMainPage()
        registerSettingsPage()
        registerContactsListPage()
        registerChatUseCase()
        registerChatPage()
    }
    
    private static func registerTabbarPage() {
        register(ITabbarNavigator.self) { TabbarNavigator(viewController: $1.get()) }
        register(ITabbarViewModel.self) { TabbarViewModel(navigator: $0.resolve(args: $1.get())) }
        register(ITabbarViewController.self) { TabbarViewController() } .resolveProperties { $1.viewModel = $0.optional(args: $1) }
    }
    
    private static func registerChatPage() {
        register(IChatNavigator.self) { ChatNavigator(viewController: $1.get()) }
        register(IChatViewModel.self) { ChatViewModel(
            navigator: $0.resolve(args: $1.get("vc")),
            chat: $1.get("chat")) }
        register(IChatViewController.self) { ChatViewController() }
            .resolveProperties {
                let args: [String : Any] = [
                    "vc" : $1,
                    "chat" : $2.get("chat") as ChatModel,
                ]
                $1.viewModel = $0.optional(args: args) }
    }
    
    private static func registerMainPage() {
        register(IMainPageNavigator.self) { MainPageNavigator(viewController: $1.get()) }
        register(IMainPageViewModel.self) { MainPageViewModel(navigator: $0.resolve(args: $1.get()), chatUseCase: $0.resolve()) }
        register(IMainPageViewController.self) { MainPageViewController() }
            .resolveProperties { $1.viewModel = $0.optional(args: $1) }
    }
    
    private static func registerSettingsPage() {
        register(ISettingsViewModel.self) { SettingsViewModel() }
        register(ISettingsViewContoller.self) { SettingsViewContoller() }
            .resolveProperties { $1.viewModel = $0.optional(args: $1) }
    }
    
    private static func registerContactsListPage() {
        register(IContactsListNavigator.self) { ContactsListNavigator(viewController: $1.get()) }
        register(IContactsListViewModel.self) { ContactsListViewModel(navigator: $0.resolve(args: $1.get())) }
        register(IContactsListViewController.self) { ContactsListViewController() }
            .resolveProperties { $1.viewModel = $0.optional(args: $1) }
    }
}
