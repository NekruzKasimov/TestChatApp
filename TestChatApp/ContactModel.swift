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
    var iconData: Data?
    
    func getIcon() -> UIImage? {
        guard let iconData = iconData else {
            return R.image.profileIcon()
        }
        return UIImage(data: iconData)
    }
}
