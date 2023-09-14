//
//  UIViewController+extension.swift
//  BookingHotel
//
//  Created by Yury on 14/09/2023.
//

import Foundation
import UIKit

// Расширение для UIViewController чтобы добавить метод hideKeyboard
extension UIViewController {
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
}
