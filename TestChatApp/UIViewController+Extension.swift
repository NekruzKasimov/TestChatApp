//
//  UIViewController+Extension.swift
//  TestChatApp
//
//  Created by Niko on 05.10.22.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import RxSwiftExt

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension Reactive where Base: UIViewController {
    
    var viewWillAppear: ControlEvent<Void> {
        return ControlEvent(events: self.sentMessage(#selector(Base.viewWillAppear)).mapTo(()))
    }
    
}
