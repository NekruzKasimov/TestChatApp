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
    
    
}
