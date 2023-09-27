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
    
    // Закрытый инициализатор, чтобы предотвратить создание новых экземпляров класса
    private init() {}

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
    
    // Метод при нажатии кнопки оплатить
    func payButtonAction(sender: UIButton, textFields: [UITextField], views: [UIView], viewConstaraints: [NSLayoutConstraint], stacksInViews: [UIStackView], buttonsUpDownPlus: [UIButton], scrollView: UIScrollView, mainStackView: UIStackView, controller: UIViewController, performSegue: @escaping () -> Void) {

        // Переменная для отслеживания, есть ли незаполненные поля
        var hasEmptyField = false
        
        let tagOffset = 21 // Отдельная константа для смещения тега

        for textField in textFields {
            // Получаем вью, в котором находится текстовое поле
            if let parentView = textField.superview {
                // Проверяем, скрыто ли вью, в котором находится текстовое поле
                if !isViewHidden(parentView, mainStackView: mainStackView) {
                    if textField.text?.isEmpty ?? true {
                        hasEmptyField = true
                        textField.backgroundColor = UIColor(red: 235/255, green: 87/255, blue: 87/255, alpha: 0.15)
                    }
                }
            }
        }

        // Проверяем, есть ли незаполненные поля
        if hasEmptyField {
            // Показываем уведомление что не все поля заполнены
            UtilityManager.shared.showAlert(from: controller, title: "Не все поля заполнены", message: "Или заполнены не корректно. Проверьте все поля помеченные красным")

            // Проходимся по всем вью и разворачиваем те вью, что не скрыты
            for (index, view) in views.enumerated() {
                if !isViewHidden(view, mainStackView: mainStackView) {
                    UtilityManager.shared.changeSizeforView(constraints: viewConstaraints, stackViews: stacksInViews, sender: sender, in: controller.view, isCollapsible: false, shouldChangeImage: false, withTag: index + tagOffset)
                    if let button = buttonsUpDownPlus.first(where: { $0.tag == index + 1 }) {
                        button.setImage(UIImage(named: "upArrow"), for: .normal)
                    }
                }
            }
        } else {
            // Нет незаполненных полей, выполняем переход по сегвею
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
