//
//  NestedTableViewController.swift
//  BookingHotel
//
//  Created by Yury on 07/09/2023.
//

import UIKit

// Контроллер вложенной таблицы для отображения деталей бронирования отеля
class NestedTableViewController: UITableViewController {
    
    // MARK: - IB Outlets
    
    // Коллекция кастомных сепараторов для ячеек таблицы
    @IBOutlet var customSeparatorForTableCell: [UIView]!
    
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Отключаем вертикальную прокрутку для таблицы
        tableView.isScrollEnabled = false
        
        // Добавляем пользовательские границы для сепараторов ячеек таблицы
        addCustomBorderForTableCellSeparator(for: customSeparatorForTableCell)
    }
    
    // MARK: - Table view
    
    // Обрабатываем выбор ячейки таблицы, меняя фоновый цвет при нажатии и выводя сообщение в лог
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        // Выводим сообщение в лог при нажатии на ячейку
        Logger.log("Кнопка была нажата, но ничего не происходит согласно тех заданию")
        
        // Анимируем изменение фонового цвета ячейки при нажатии
        UIView.animate(withDuration: 0.1, animations: {
            cell?.contentView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 248/255, alpha: 1)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                cell?.contentView.backgroundColor = UIColor(red: 251/255, green: 251/255, blue: 252/255, alpha: 1)
            })
        }
    }
    
    
}

// MARK: - Methods

extension NestedTableViewController {
    
    // Метод для добавления пользовательских границ сепаратора ячеек таблицы
    func addCustomBorderForTableCellSeparator(for views: [UIView]) {
        for view in views {
            
            // Устанавливаем ширину и цвет границы для каждого разделителя ячейки
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor(red: 130/255, green: 135/255, blue: 150/255, alpha: 0.15).cgColor
            view.layer.backgroundColor = UIColor(red: 130/255, green: 135/255, blue: 150/255, alpha: 0.15).cgColor
        }
    }
    
}
