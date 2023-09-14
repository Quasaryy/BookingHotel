//
//  UIManager.swift
//  BookingHotel
//
//  Created by Yury on 14/09/2023.
//

import Foundation
import UIKit

class UIManager {
    
    // MARK: - Propertis
    
    static let shared = UIManager()
    
    // MARK: - Init
    
    private init() {}
    
}

// MARK: - Methods

extension UIManager {
    
    // MARK: Третий экран
    
    func setupViewElements(views: [UIView]) {
        for view in views {
            UtilityManager.shared.cornerRadius(for: view, radius: 15)
        }
    }
    
    func setupButtons(buttons: [UIButton], radius: CGFloat) {
        for button in buttons {
            UtilityManager.shared.cornerRadius(for: button, radius: radius)
        }
    }
    
    func setupTextFields(textFields: [UITextField], radius: CGFloat) {
        TextFieldManager.shared.textFiledsConfig(for: textFields, radius: radius)
    }
    
    func setupStackViewWithStar(stackView: UIStackView) {
        UtilityManager.shared.hotelLevel(stackView: stackView)
    }
    
    func setupViewWithBorder(view: UIView) {
        UtilityManager.shared.configureBordersForBottomView(view: view)
    }
    
    func setupKeyboardHiding(viewController: UIViewController, scrollView: UIScrollView) {
        TextFieldManager.shared.setupGestureToHideKeyboard(viewController: viewController)
        ScrollViewManager.shared.setupToHideKeyboardOnScroll(scrollView: scrollView, viewController: viewController)
    }
    
    // MARK: Четвертый экран
    
    func setupFourthScreenUI(superButton: UIButton, bottomViewWithButton: UIView, viewWithImage: UIView, orderConfirmation: UILabel) {
        
            // Закругляем кнопку Super!
            UtilityManager.shared.cornerRadius(for: superButton, radius: 15)
            
            // Задаем бордер для нижнего вью
            UtilityManager.shared.configureBordersForBottomView(view: bottomViewWithButton)
            
            // Делаем круг из вью с поздравительным изображением
            viewWithImage.layer.cornerRadius = viewWithImage.frame.size.width / 2
            
            // Текст для подтверждения заказа
            orderConfirmation.text = UtilityManager.shared.orderConfirmation()
        }
    
    
    // MARK: Первый экран
    
    
    
    // MARK: Второй экран
    
    
    
}
