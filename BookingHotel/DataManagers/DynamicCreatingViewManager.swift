//
//  DynamicCreatingViewManager.swift
//  BookingHotel
//
//  Created by Yury on 08/09/2023.
//

import Foundation
import UIKit

class DynamicCreatingViewManager {
    
    // MARK: - Properties
    
    // Синглтон экземпляр класса, чтобы избежать множественных экземпляров этого класса в разных частях приложения
    static var shared = DynamicCreatingViewManager()
    
    // Константы для горизонтальных отступов и расстояния между вью
    private let horizontalPadding: CGFloat = 16
    private let labelSpacing: CGFloat = 8
    
    // MARK: - Init
    
    // Закрытый инициализатор, чтобы предотвратить создание новых экземпляров класса
    private init() {}
    
}

// MARK: - Methods

extension DynamicCreatingViewManager {
    
    // MARK: Создание лейблов
    
    func configLabelsWithData(with peculiarities: [String], verticalStackView: UIStackView, customCell: UITableViewCell) {

        // Удаление всех текущих subviews в verticalStackView
        for arrangedSubview in verticalStackView.arrangedSubviews {
            verticalStackView.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
        
        // Создание первого горизонтального StackView
        var horizontalStackView: UIStackView = createNewHorizontalStackView()
        verticalStackView.addArrangedSubview(horizontalStackView)
        
        // Определение доступной ширины для вью с лейблами
        var remainingWidth = customCell.frame.width - 2 * horizontalPadding
        
        // Итерация по каждому элементу данных (предположим, что это строки)
        for text in peculiarities {
            
            // Создание новой вью и лейбла
            let containerView = UIView()
            containerView.backgroundColor = UIColor(red: 251/255, green: 251/255, blue: 252/255, alpha: 1)
            containerView.layer.cornerRadius = 5
            containerView.clipsToBounds = true
            
            let label = UILabel()
            label.text = text
            label.font = UIFont(name: "SFProDisplay-Medium", size: 16)
            label.textColor = UIColor(red: 130/255, green: 135/255, blue: 150/255, alpha: 1)
            
            containerView.addSubview(label)
            
            // Установка констрейнтов для лейбла внутри вью
            label.translatesAutoresizingMaskIntoConstraints = false
            let topConstraint = label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5)
            let bottomConstraint = label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5)
            let leadingConstraint = label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
            let trailingConstraint = label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
            
            // Устанавливаем приоритеты к констрейнтам
            topConstraint.priority = .defaultHigh
            
            // Активируем констрейнты
            NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
            
            // Измерение ширины текста
            let titleWidth = textWidth(text, font: label.font, height: 20)
            
            // Проверка, если вью не помещается, создаем новый горизонтальный StackView
            if remainingWidth - (titleWidth + labelSpacing) < 0 {
                horizontalStackView = createNewHorizontalStackView()
                verticalStackView.addArrangedSubview(horizontalStackView)
                remainingWidth = customCell.frame.width - 2 * horizontalPadding
            }
            
            // Уменьшение доступной ширины
            remainingWidth -= (titleWidth + labelSpacing)
            
            // Добавление вью в горизонтальный StackView
            horizontalStackView.addArrangedSubview(containerView)
        }
    }
    
    
    // Приватный метод для создания нового горизонтального StackView
    private func createNewHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = labelSpacing
        return stackView
    }
    
    // Приватный метод для измерения ширины текста с заданными ограничениями
    private func textWidth(_ text: String, font: UIFont?, height: CGFloat) -> CGFloat {
        guard let font = font else { return 0 }
        return text.width(withConstrainedHeight: height, font: font)
    }
    
}
