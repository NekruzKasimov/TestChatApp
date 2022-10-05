//
//  ContactTableViewCell.swift
//  TestChatApp
//
//  Created by Niko on 05.10.22.
//

import Foundation
import UIKit
import SnapKit

final class ContactTableViewCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let contactImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.selectionStyle = .none
        contentView.backgroundColor = .white
        titleLabel.textColor = .black
        
        let stackView = UIStackView()
        stackView.addArrangedSubview(contactImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.axis = .horizontal
        stackView.spacing = 5
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(20)
            $0.trailing.bottom.equalToSuperview().offset(-20)
        }
        
        contactImageView.snp.makeConstraints {
            $0.height.width.equalTo(30)
        }
    }
    
    func fill(contact: ContactModel) {
        self.titleLabel.text = contact.name
        contactImageView.image = contact.getIcon()
    }
}
