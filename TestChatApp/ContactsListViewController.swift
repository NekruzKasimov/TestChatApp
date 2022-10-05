//
//  ContactsListViewController.swift
//  TestChatApp
//
//  Created by Niko on 04.10.22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol IContactsListPage: AnyObject {
    var viewModel: IContactsListViewModel! { set get }
}

typealias IContactsListViewController = BaseViewController & IContactsListPage

final class ContactsListViewController: IContactsListViewController {
    var viewModel: IContactsListViewModel!
    var tableView = UITableView()
    
    var contacts = [ContactModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }
    
    func setupView() {
        tableView.backgroundColor = .white
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: R.string.localizable.mainPageCellIdentifier())
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
    
    func bind() {
        let input = ContactsListViewModel.Input(
            viewWillAppear: rx.viewWillAppear.asSignal(),
            itemSelected: tableView.rx.itemSelected.asSignal())
        
        let output = viewModel.transform(input)
        
        disposeBag.insert([output.contacts.emit(onNext: { [unowned self] contacts in
            self.contacts = contacts
            self.tableView.reloadData()
        })])
    }
}

extension ContactsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.string.localizable.mainPageCellIdentifier(), for: indexPath) as! ContactTableViewCell
        cell.fill(contact: contacts[indexPath.row])
        return cell
    }
    
    
}
