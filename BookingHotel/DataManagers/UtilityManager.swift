//
//  UtilityManager.swift
//  BookingHotel
//
//  Created by Yury on 08/09/2023.
//

import Foundation
import UIKit

class UtilityManager {
    
    // MARK: - Properties
    
    // Синглтон экземпляр класса, чтобы избежать множественных экземпляров этого класса в разных частях приложения
    static var shared = UtilityManager()
    
    // Высота констрейнта для развернутой вью
    private let expandedViewHeight: CGFloat = 430.0
    private let collapsedViewHeight: CGFloat = 58.0
    
    // MARK: - Init
    
    private init() {}
    
}

// MARK: - Methods

extension UtilityManager {
    
    // Настройка внешнего вида навигационной панели
    func setupNavigationBar(for viewController: UIViewController) {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        viewController.navigationController?.navigationBar.standardAppearance = appearance
        viewController.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        guard let font = UIFont(name: "SFProDisplay-Medium", size: 18) else { return }
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black, .font: font]
    }
    
    func changeBackButtonTextAndColor(for viewController: UIViewController) {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backButton.tintColor = .black
        viewController.navigationItem.backBarButtonItem = backButton
    }
    
    // Метод для форматирования минимальной цены с добавлением разделителя тысяч
    func formatMinimalPrice(_ minimalPrice: Int, withPrefix: Bool = true) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        if let formattedNumber = formatter.string(from: NSNumber(value: minimalPrice)) {
            if withPrefix {
                return "от \(formattedNumber) ₽"
            } else {
                return "\(formattedNumber) ₽"
            }
        } else {
            return "Цена не доступна"
        }
    }
    
    // Настройка границ для bottomView
    func configureBordersForBottomView(view: UIView) {
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 232/255, green: 233/255, blue: 236/255, alpha: 1).cgColor
    }
    
    // Настройка закргуления углов чего либо
    func cornerRadius<T: UIView>(for element: T, radius: CGFloat) {
        element.layer.cornerRadius = radius
    }
    
    // Настройка вида стек вью с оценкой отеля
    func hotelLevel(stackView stackViewWithStar: UIStackView) {
        stackViewWithStar.backgroundColor = UIColor(red: 1, green: 199/255, blue: 0/255, alpha: 0.2)
        stackViewWithStar.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackViewWithStar.isLayoutMarginsRelativeArrangement = true
        UtilityManager.shared.cornerRadius(for: stackViewWithStar, radius: 5)
    }
    
    // Метод изменения размера вью
    func changeSizeforView(constraints: [NSLayoutConstraint], stackViews: [UIStackView], sender: UIButton, in view: UIView, withTag tag: Int, isCollapsible: Bool = true, shouldChangeImage: Bool = true) {
        guard let stackView = stackViews.first(where: { $0.tag == tag }) else {
            return
        }

        guard let constraint = constraints.first(where: { $0.identifier == "\(tag)" }) else {
            return
        }

        if constraint.constant == collapsedViewHeight {
            stackView.isHidden = false
            constraint.constant = expandedViewHeight
            if shouldChangeImage {
                sender.setImage(UIImage(named: "upArrow"), for: .normal)
            }
        } else if isCollapsible {
            stackView.isHidden = true
            constraint.constant = collapsedViewHeight
            if shouldChangeImage {
                sender.setImage(UIImage(named: "downArrow"), for: .normal)
            }
        }

        UIView.animate(withDuration: 0.3) {
            view.layoutIfNeeded()
        }
    }

    // Генерация случайного числа из 6 цифр
    private func generateRandomSixDigitNumber() -> Int {
        let randomNumber = Int.random(in: 100000..<1000000)
        return randomNumber
    }
    
    // Текст для подтверждения заказа
    func orderConfirmation() -> String {
        return "Подтверждение заказа №\(generateRandomSixDigitNumber()) может занять некоторое время (от 1 часа до суток). Как только мы получим ответ от туроператора, вам на почту придет уведомление."
    }
    
    // Алерт контроллер
    func showAlert(from viewController: UIViewController?, title: String, message: String) {
            guard let viewController = viewController else {
                return // Если передан nil, просто выходим из метода
            }
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.overrideUserInterfaceStyle = .light // Устанавливаем светлый стиль
            let buttonOK = UIAlertAction(title: "OK", style: .default)
            alert.addAction(buttonOK)
            viewController.present(alert, animated: true)
        }
    
}
