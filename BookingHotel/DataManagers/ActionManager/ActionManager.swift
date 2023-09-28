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
    
    // MARK: Блок для кнопки оплатить
    
    // Метод для сворачивания и разворачивания секции
    func toggleSectionVisibility(sender: UIButton, constraints: [NSLayoutConstraint], stackViews: [UIStackView], in view: UIView, withTag tagOffset: Int) {
        let newTag = sender.tag + tagOffset
        
        if (1...9).contains(sender.tag) {
            UtilityManager.shared.changeSizeforView(constraints: constraints, stackViews: stackViews, sender: sender, in: view, withTag: newTag)
        }
    }
    
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
    func handleUnfilledFields(uiContext: UIContext, tagOffset: Int) {
        for (index, view) in uiContext.views.enumerated() {
            if !isViewHidden(view, mainStackView: uiContext.mainStackView) {
                UtilityManager.shared.changeSizeforView(constraints: uiContext.viewConstraints, stackViews: uiContext.stacksInViews, sender: uiContext.buttonsUpDownPlus.first!, in: uiContext.mainStackView, isCollapsible: false, shouldChangeImage: false, withTag: index + tagOffset)
                
                if let button = uiContext.buttonsUpDownPlus.first(where: { $0.tag == index + 1 }) {
                    button.setImage(UIImage(named: "upArrow"), for: .normal)
                }
            }
        }
    }
    
    // Основной метод кнопки оплатить
    func payButtonAction(uiContext: UIContext, actionContext: ActionContext) {
        // Устанавливаем смещение тега для кнопок
        let tagOffset = 21
        // Проверяем, есть ли пустые поля ввода
        let hasEmptyField = checkTextFields(uiContext.textFields, mainStackView: uiContext.mainStackView)
        // Если есть пустые поля
        if hasEmptyField {
            // Показываем предупреждение пользователю
            UtilityManager.shared.showAlert(from: actionContext.controller, title: "Не все поля заполнены", message: "Или заполнены не корректно. Проверьте все поля помеченные красным")
            // Обрабатываем вьюшки, где поля не заполнены
            handleUnfilledFields(uiContext: uiContext, tagOffset: tagOffset)
        } else {
            // Если все поля заполнены, изменяем текст и цвет кнопки "Назад"
            UtilityManager.shared.changeBackButtonTextAndColor(for: actionContext.controller)
            // Выполняем переход к следующему экрану
            actionContext.performSegue()
        }
        
        // Прокручиваем ScrollView до нижнего края (когда открываются вью с незаполенными полями
        let bottomOffset = CGPoint(x: 0, y: uiContext.scrollView.contentSize.height - uiContext.scrollView.bounds.size.height + 33)
        uiContext.scrollView.setContentOffset(bottomOffset, animated: true)
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
