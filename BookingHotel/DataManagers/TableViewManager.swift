//
//  TableViewManager.swift
//  BookingHotel
//
//  Created by Yury on 08/09/2023.
//

import Foundation
import UIKit

class TableViewManager {
    
    // MARK: - Propeties
    
    // Синглтон экземпляр класса, чтобы избежать множественных экземпляров этого класса в разных частях приложения
    static var shared = TableViewManager()
    
    // MARK: Init
    
    // Закрытый инициализатор, чтобы предотвратить создание новых экземпляров класса
    private init() {}
    
}

// MARK: - Methods

extension TableViewManager {
    
    // Чтобы при оттягивании таблицы вниз, пользователь видел белый фон, а не фон таблицы
    func wniteBackgroundWnenPullingTable(view: UIView, tableView: UITableView) {
        view.frame = CGRect(x: 0, y: -300, width: tableView.bounds.width, height: 300)
        view.backgroundColor = .white
        tableView.addSubview(view)
    }
    
    // Метод для добавления пользовательских границ сепаратора ячеек таблицы
    func addCustomBorderForTableCellSeparator(for views: [UIView]) {
        for view in views {
            
            // Устанавливаем ширину и цвет границы для каждого разделителя ячейки
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor(red: 130/255, green: 135/255, blue: 150/255, alpha: 0.15).cgColor
            view.layer.backgroundColor = UIColor(red: 130/255, green: 135/255, blue: 150/255, alpha: 0.15).cgColor
        }
    }
    
    // MARK: Внешний вид ячейки
    
    // Метод для настройки внешнего вида ячейки
    func setupViewAppearance(customCell: UITableViewCell, shouldApplyCornerRadius: Bool = true) {
        
        // Установка фоновых цветов
        customCell.backgroundColor = UIColor.clear
        customCell.contentView.backgroundColor = .white
        
        // Скругление углов для contentView
        if shouldApplyCornerRadius {
            UtilityManager.shared.cornerRadius(for: customCell.contentView, radius: 15)
        }
    }
    
    // MARK: Вложенный контроллер таблицы
    
    // Метод для инициализации и настройки вложенного контроллера таблицы в кастомной ячейке
    func setupNestedTableViewControllerInCell(for cell: Main2TableViewCell) {
        guard cell.nestedTableViewController == nil else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        cell.nestedTableViewController = storyboard.instantiateViewController(withIdentifier: "NestedTableViewController") as? NestedTableViewController
        
        guard let tableView = cell.nestedTableViewController?.tableView else { return }
        
        cell.containerView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: cell.containerView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: cell.containerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: cell.containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: cell.containerView.trailingAnchor)
        ])
    }
    
    // Устанавливаем дополнительный отступ снизу для tableView
    func additionalPadding(for number: CGFloat, tableView: UITableView, view: UIView) {
        let additionalPadding: CGFloat = number
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom + additionalPadding, right: 0)
    }
    
}
