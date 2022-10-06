//
//  MainPageViewController.swift
//  TestChatApp
//
//  Created by Niko on 03.10.22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol IMainScreen: AnyObject {
    var viewModel: IMainPageViewModel! { get set }
}

typealias IMainPageViewController = BaseViewController & IMainScreen

final class MainPageViewController: IMainPageViewController {
    var viewModel: IMainPageViewModel!
    let tableView = UITableView()
    
    var chats = [ChatModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }
    
    func setupView() {
        tableView.backgroundColor = .white
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: R.string.localizable.mainPageCellIdentifier())
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
    
    func bind() {
        let input = MainPageViewModel.Input(
            viewWillAppear: rx.viewWillAppear.asSignal(),
            itemSelected: tableView.rx.itemSelected.asSignal())
        
        let output = viewModel.transform(input)
        
        disposeBag.insert([output.chats.emit(onNext: { [unowned self] chats in
            self.chats = chats
            self.tableView.reloadData()
        })])
    }
}

extension MainPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.string.localizable.mainPageCellIdentifier(), for: indexPath) as! MainTableViewCell
        cell.fill(chat: chats[indexPath.row])
        return cell
    }
}
