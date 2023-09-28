//
//  ActionManagerSetting.swift
//  BookingHotel
//
//  Created by Yury on 28/09/2023.
//

import UIKit

struct UIContext {
    var textFields: [UITextField]
    var views: [UIView]
    var viewConstraints: [NSLayoutConstraint]
    var stacksInViews: [UIStackView]
    var buttonsUpDownPlus: [UIButton]
    var scrollView: UIScrollView
    var mainStackView: UIStackView
}

struct ActionContext {
    var sender: UIButton
    var controller: UIViewController
    var performSegue: () -> Void
}

struct UIFields {
    var textFields: [UITextField]
    var views: [UIView]
    var viewConstraints: [NSLayoutConstraint]
    var stacksInViews: [UIStackView]
    var buttonsUpDownPlus: [UIButton]
    var scrollView: UIScrollView
    var mainStackView: UIStackView
    var buttons: [UIButton]
    var tagOffset: Int
}
