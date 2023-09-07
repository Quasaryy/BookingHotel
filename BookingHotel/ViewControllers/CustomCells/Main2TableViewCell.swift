//
//  Main2TableViewCell.swift
//  BookingHotel
//
//  Created by Yury on 06/09/2023.
//

import UIKit

class Main2TableViewCell: UITableViewCell {
    
    // MARK: - Propeties
    
    // Константы для горизонтальных отступов и расстояния между вью
    private let horizontalPadding: CGFloat = 16
    private let labelSpacing: CGFloat = 8
    
    // Ссылка на вложенный контроллер таблицы, который будет использоваться в данной ячейке
    var nestedTableViewController: NestedTableViewController?
    
    // MARK: - IB Outlets
    
    // Ссылки на элементы интерфейса, созданные в Interface Builder
    @IBOutlet weak var hotelDescription: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var verticalStackView: UIStackView!
    
    // MARK: - awakeFromNib
    
    // Метод, который вызывается после того как объект был загружен из Interface Builder
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Настройка вложенного контроллера таблицы и внешнего вида элементов интерфейса
        setupNestedTableViewController()
        setupViewAppearance()
        
    }
    
}

// MARK: - Methods

extension Main2TableViewCell {
    
    // MARK: Вложенная таблица
    
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
    
    // MARK: Внешний вид ячейки
    
    // Приватный метод для настройки внешнего вида элементов ячейки
    private func setupViewAppearance() {
        
        // Установка фоновых цветов
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = .white
        
        // Скругление углов для contentView
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        
    }
    
    // MARK: Создание лейблов
    
    func configLabelsWithData(with dataModel: Hotel) {
        // Удаление всех текущих subviews в verticalStackView
        for arrangedSubview in verticalStackView.arrangedSubviews {
            verticalStackView.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
        
        // Создание первого горизонтального StackView
        var horizontalStackView: UIStackView = createNewHorizontalStackView()
        verticalStackView.addArrangedSubview(horizontalStackView)
        
        // Определение доступной ширины для вью с лейблами
        var remainingWidth = self.frame.width - 2 * horizontalPadding
        
        // Итерация по каждому элементу данных (предположим, что это строки)
        for text in dataModel.aboutTheHotel.peculiarities {
            
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
                remainingWidth = self.frame.width - 2 * horizontalPadding
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
