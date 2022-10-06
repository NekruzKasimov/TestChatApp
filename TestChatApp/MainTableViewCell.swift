//
//  MainTableViewCell.swift
//  TestChatApp
//
//  Created by Niko on 03.10.22.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

final class MainTableViewCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
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
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        messageLabel.textColor = .black
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        
        contactImageView.layer.cornerRadius = 20
        contactImageView.layer.masksToBounds = true
        
        let labelsStackView = UIStackView()
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(messageLabel)
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 5
        
        
        let stackView = UIStackView()
        stackView.addArrangedSubview(contactImageView)
        stackView.addArrangedSubview(labelsStackView)
        stackView.axis = .horizontal
        stackView.spacing = 5
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(20)
            $0.trailing.bottom.equalToSuperview().offset(-20)
        }
        
        contactImageView.snp.makeConstraints {
            $0.height.width.equalTo(40)
        }
    }
    
    
    func fill(chat: ChatModel) {
        titleLabel.text = chat.chatName
        messageLabel.text = chat.lastMessage
        if let url = chat.iconUrl {
            contactImageView.sd_setImage(with: URL(string: url), placeholderImage: R.image.profileIcon())
        } else {
            contactImageView.image = R.image.profileIcon()
        }
    }
}
