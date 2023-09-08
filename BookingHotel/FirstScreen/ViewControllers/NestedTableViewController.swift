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
        
        // Добавляем пользовательские границы для сепараторов ячеек таблицы
        TableViewManager.shared.addCustomBorderForTableCellSeparator(for: customSeparatorForTableCell)
    }
    
    // MARK: - Table view
    
    // Обрабатываем выбор ячейки таблицы, меняя фоновый цвет при нажатии и выводя сообщение в лог
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Выводим сообщение в лог при нажатии на ячейку
        Logger.log("Кнопка была нажата, но ничего не происходит согласно тех заданию")
        
        // Анимируем изменение фонового цвета ячейки при нажатии
        AnimationManager.shared.animateCellWhenSelected(indexPath: indexPath, tableView: tableView)
    }
    
}
