//
//  TabbarViewController.swift
//  TestChatApp
//
//  Created by Niko on 03.10.22.
//

import UIKit
import SnapKit
import Resolver
import RxCocoa
import RxSwift
import Resolver

protocol ITabbarScreen: AnyObject {
    var viewModel: ITabbarViewModel! { set get }
}

typealias ITabbarViewController = UITabBarController & ITabbarScreen

final class TabbarViewController: ITabbarViewController {
    
    var viewModel: ITabbarViewModel! {
        didSet {
            bind()
        }
    }
    
    private var rightBarButton = UIBarButtonItem()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setControllers()
    }
    
    func setupView() {
        view.backgroundColor = .white
        rightBarButton = UIBarButtonItem(title: R.string.localizable.tabbarAddButtonTitle(), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func bind() {
        let input = TabbarViewModel.Input(addContacts: rightBarButton.rx.tap.asSignal())

        let output = viewModel.transform(input)

        disposeBag.insert([output.contactsOutput.emit()])
    }
    
    func setControllers() {
        let mainScreen = Resolver.resolve(IMainPageViewController.self)
        let profileScreen = Resolver.resolve(ISettingsViewContoller.self)
        let icon1 = UITabBarItem(title: R.string.localizable.tabbarMainViewControllerTitle(), image: UIImage(named: ""), selectedImage: UIImage(named: ""))
        let icon2 = UITabBarItem(title: R.string.localizable.tabbarSettingsViewControllerTitle(), image: UIImage(named: ""), selectedImage: UIImage(named: ""))
        mainScreen.tabBarItem = icon1
        profileScreen.tabBarItem = icon2
        let controllers: [BaseViewController] = [mainScreen, profileScreen]
        self.viewControllers = controllers
    }
}
