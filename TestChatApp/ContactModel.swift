//
//  ContactModel.swift
//  TestChatApp
//
//  Created by Niko on 05.10.22.
//

import Foundation
import UIKit

struct ContactModel {
    var name: String
    var iconUrl: String?
    
    func getIcon() -> UIImage? {
        guard let iconUrl = iconUrl else {
            return R.image.profileIcon()
        }
        let url = URL(string: iconUrl)
        let data = try? Data(contentsOf: url!)
        return UIImage(data: data!)
    }
}
