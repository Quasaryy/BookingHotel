//
//  ActionManager.swift
//  BookingHotel
//
//  Created by Yury on 14/09/2023.
//

import Foundation
import UIKit

class ActionManager {
    
    // MARK: - Properties
    
    static let shared = ActionManager()
    
    // MARK: - Init
    
    private init() {
        // Закрытый инициализатор, чтобы предотвратить создание новых экземпляров класса
    }

}

// MARK: - Methods

extension ActionManager {
    
    // Метод добавления нового туриста
    func addNewCustomer(currentViewIndex: inout Int, mainStackView: UIStackView, controller: UIViewController) {
        
        if currentViewIndex < 12 {
            
            // Делаем вью с текущим индексом видимым
            mainStackView.arrangedSubviews[currentViewIndex].isHidden = false
            
            currentViewIndex += 1
            // Увеличиваем индекс на 1 для следующего вызова
            
        } else {
            UtilityManager.shared.showAlert(from: controller, title: "Достигнут максимум туристов", message: "Вы добавили максимальное возможное колиичество туристов")
        }
    }
    
    // Метод для сворачивания и разворачивания секции
        func toggleSectionVisibility(sender: UIButton, constraints: [NSLayoutConstraint], stackViews: [UIStackView], in view: UIView, withTag tagOffset: Int) {
            let newTag = sender.tag + tagOffset

            if (1...9).contains(sender.tag) {
                UtilityManager.shared.changeSizeforView(constraints: constraints, stackViews: stackViews, sender: sender, in: view, withTag: newTag)
            }
        }
    
    // MARK: Блок для кнопки оплатить
    
    // Функция для проверки, есть ли пустые текстовые поля
    func checkTextFields(_ textFields: [UITextField], mainStackView: UIStackView) -> Bool {
        var hasEmptyField = false
        for textField in textFields {
            guard let parentView = textField.superview else { continue }
            // Проверяем, является ли видимым родительское вью данного текстового поля
            if !isViewHidden(parentView, mainStackView: mainStackView),
               textField.text?.isEmpty ?? true {
                hasEmptyField = true
                textField.backgroundColor = UIColor(red: 235/255, green: 87/255, blue: 87/255, alpha: 0.15)
            }
        }
        return hasEmptyField
    }

    // Функция для обработки незаполненных полей и сворачивания/разворачивания соответствующих вью
    func handleUnfilledFields(in views: [UIView], withConstraints viewConstraints: [NSLayoutConstraint], stacks: [UIStackView], mainStackView: UIStackView, sender: UIButton, controller: UIViewController, buttons: [UIButton], tagOffset: Int) {
        for (index, view) in views.enumerated() {
            // Проверяем, является ли видимым данное вью
            if !isViewHidden(view, mainStackView: mainStackView) {
                UtilityManager.shared.changeSizeforView(constraints: viewConstraints, stackViews: stacks, sender: sender, in: controller.view, isCollapsible: false, shouldChangeImage: false, withTag: index + tagOffset)
                if let button = buttons.first(where: { $0.tag == index + 1 }) {
                    button.setImage(UIImage(named: "upArrow"), for: .normal)
                }
            }
        }
    }

    func payButtonAction(sender: UIButton, textFields: [UITextField], views: [UIView], viewConstraints: [NSLayoutConstraint], stacksInViews: [UIStackView], buttonsUpDownPlus: [UIButton], scrollView: UIScrollView, mainStackView: UIStackView, controller: UIViewController, performSegue: @escaping () -> Void) {
        let tagOffset = 21
        
        // Проверка наличия пустых полей
        let hasEmptyField = checkTextFields(textFields, mainStackView: mainStackView)

        if hasEmptyField {
            // Показываем уведомление если есть пустые поля
            UtilityManager.shared.showAlert(from: controller, title: "Не все поля заполнены", message: "Или заполнены не корректно. Проверьте все поля помеченные красным")
            // Обрабатываем незаполненные поля
            handleUnfilledFields(in: views, withConstraints: viewConstraints, stacks: stacksInViews, mainStackView: mainStackView, sender: sender, controller: controller, buttons: buttonsUpDownPlus, tagOffset: tagOffset)
        } else {
            // Если все поля заполнены, выполняем переход
            UtilityManager.shared.changeBackButtonTextAndColor(for: controller)
            performSegue()
        }

        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height + 33)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    private func isViewHidden(_ view: UIView?, mainStackView: UIStackView) -> Bool {
        guard let view = view else { return false }

        // Перебираем супервью до тех пор, пока не дойдем до нужного вью
        var currentSuperview = view.superview
        while let superview = currentSuperview {
            if superview == mainStackView {
                break
            }
            if superview.isHidden {
                return true
            }
            currentSuperview = superview.superview
        }

        return false
    }
    
}
