//
//  MainTableViewCell.swift
//  TestChatApp
//
//  Created by Niko on 03.10.22.
//

import Foundation
import UIKit
import SnapKit

final class MainTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.selectionStyle = .none
    }
}
