//
//  ProfileIconTableViewCell.swift
//  TestChatApp
//
//  Created by Niko on 09.10.22.
//

import Foundation
import UIKit

final class ProfileIconTableViewCell: UITableViewCell {
    let profileImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        profileImage.layer.cornerRadius = 40
        profileImage.layer.masksToBounds = true
        profileImage.image = R.image.profileIcon()
        
        contentView.addSubview(profileImage)
        
        profileImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(80)
        }
    }
}
