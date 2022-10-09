//
//  SettingsViewContoller.swift
//  TestChatApp
//
//  Created by Niko on 04.10.22.
//

import Foundation
import UIKit

protocol ISettingsPage: AnyObject {
    var viewModel: ISettingsViewModel! { set get }
}

typealias ISettingsViewContoller = BaseViewController & ISettingsPage

final class SettingsViewContoller: ISettingsViewContoller {
    var viewModel: ISettingsViewModel!
    let tableView = UITableView()
    
    var settings: [String] = ["Поделиться", "Приватность", "Сохраненные", "Язык"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
     
    func setupView() {
        tableView.backgroundColor = .white
        tableView.register(ProfileIconTableViewCell.self, forCellReuseIdentifier: "ProfileCell")
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
}

extension SettingsViewContoller: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return settings.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileIconTableViewCell
            return cell
        } else {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.textLabel?.text = settings[indexPath.row]
            return cell
        }
    }
}
