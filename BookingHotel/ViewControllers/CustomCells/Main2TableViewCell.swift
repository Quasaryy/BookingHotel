//
//  Main2TableViewCell.swift
//  BookingHotel
//
//  Created by Yury on 06/09/2023.
//

import UIKit

class Main2TableViewCell: UITableViewCell {
    
    // MARK: - Propeties
    
    // Константы для горизонтальных отступов и расстояния между кнопками
    private let horizontalPadding: CGFloat = 16
    private let buttonSpacing: CGFloat = 8
    
    // Ссылка на вложенный контроллер таблицы, который будет использоваться в данной ячейке
    var nestedTableViewController: NestedTableViewController?
    
    // MARK: - IB Outlets
    
    // Ссылки на элементы интерфейса, созданные в Interface Builder
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet var hotelAdvantagesButtons: [UIButton]!
    @IBOutlet weak var hotelDescription: UILabel!
    
    // MARK: - awakeFromNib
    
    // Метод, который вызывается после того как объект был загружен из Interface Builder
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Настройка вложенного контроллера таблицы и внешнего вида элементов интерфейса
        setupNestedTableViewController()
        setupViewAppearance()
    }
    
    // MARK: - IB Actions
    
    // Метод, вызываемый при нажатии на одну из кнопок преимуществ отеля
    @IBAction func advantagesButtonsTapped(_ sender: UIButton) {
        // Логирование названия кнопки, на которую нажали
        if let buttonTitle = sender.currentTitle {
            Logger.log("Кнопка с названием \"\(buttonTitle)\" была нажата")
        }
    }
}

// MARK: - Methods

extension Main2TableViewCell {
    
    // Приватный метод для инициализации и настройки вложенного контроллера таблицы
    private func setupNestedTableViewController() {
        if nestedTableViewController == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            nestedTableViewController = storyboard.instantiateViewController(withIdentifier: "NestedTableViewController") as? NestedTableViewController
            
            guard let tableView = nestedTableViewController?.tableView else { return }
            
            self.containerView.addSubview(tableView)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: containerView.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            ])
        }
    }
    
    // Приватный метод для настройки внешнего вида элементов ячейки
    private func setupViewAppearance() {
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
    
    // Приватный метод для измерения ширины текста с заданными ограничениями
    private func textWidth(_ text: String, font: UIFont, height: CGFloat) -> CGFloat {
        return text.width(withConstrainedHeight: height, font: font)
    }
    
    // Метод для настройки заголовков кнопок на основе данных отеля (модели данных)
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
    
    // Приватный метод для создания нового горизонтального StackView
    private func createNewHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = buttonSpacing
        return stackView
    }
}
