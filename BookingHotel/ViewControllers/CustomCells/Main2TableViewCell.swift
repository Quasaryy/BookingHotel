//
//  Main2TableViewCell.swift
//  BookingHotel
//
//  Created by Yury on 06/09/2023.
//

import UIKit

class Main2TableViewCell: UITableViewCell {
    
    // Константы для горизонтальных отступов и расстояния между кнопками
    private let horizontalPadding: CGFloat = 16
    private let buttonSpacing: CGFloat = 8
    
    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet var hotelAdvantagesButtons: [UIButton]!
    @IBOutlet weak var hotelDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Установка фоновых цветов
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = .white
        
        // Скругление углов для contentView
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        
        // Скругление углов для каждой кнопки
        for button in hotelAdvantagesButtons {
            button.layer.cornerRadius = 5
        }
    }
    
    // Вспомогательная функция для измерения ширины текста
    private func textWidth(_ text: String, font: UIFont, height: CGFloat) -> CGFloat {
        return text.width(withConstrainedHeight: height, font: font)
    }
    
    // Функция для настройки заголовков кнопок на основе модели данных
    func configButtonTitles(with dataModel: Hotel) {
        // Удаление всех текущих subviews в verticalStackView
        for arrangedSubview in verticalStackView.arrangedSubviews {
            verticalStackView.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
        
        // Создание первого горизонтального StackView
        var horizontalStackView: UIStackView = createNewHorizontalStackView()
        verticalStackView.addArrangedSubview(horizontalStackView)
        
        // Определение доступной ширины для кнопок
        var remainingWidth = self.frame.width - 2 * horizontalPadding
        
        // Итерация по каждой особенности отеля
        for (index, peculiarity) in dataModel.aboutTheHotel.peculiarities.enumerated() {
            // Прекращение цикла, если больше нет доступных кнопок
            if index >= hotelAdvantagesButtons.count {
                break
            }
            
            // Установка текста для кнопки
            let button = hotelAdvantagesButtons[index]
            button.setTitle(peculiarity, for: .normal)
            
            // Измерение ширины текста
            let titleWidth = textWidth(peculiarity, font: button.titleLabel!.font, height: 20)
            let totalButtonWidth = titleWidth
            
            // Проверка, если кнопка не помещается, создаем новый горизонтальный StackView
            if remainingWidth - (totalButtonWidth + buttonSpacing) < 0 {
                horizontalStackView = createNewHorizontalStackView()
                verticalStackView.addArrangedSubview(horizontalStackView)
                remainingWidth = self.frame.width - 2 * horizontalPadding
            }
            
            // Уменьшение доступной ширины
            remainingWidth -= (totalButtonWidth + buttonSpacing)
            
            // Добавление кнопки в горизонтальный StackView
            horizontalStackView.addArrangedSubview(button)
        }
    }
    
    // Функция для создания нового горизонтального StackView
    private func createNewHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = buttonSpacing
        return stackView
    }
}
