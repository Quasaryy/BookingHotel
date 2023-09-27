//
//  AnimationManager.swift
//  BookingHotel
//
//  Created by Yury on 08/09/2023.
//

import Foundation
import UIKit

class AnimationManager {
    
    // MARK: - Propeties
    
    // Синглтон экземпляр класса, чтобы избежать множественных экземпляров этого класса в разных частях приложения
    static var shared = AnimationManager()
    
    // MARK: Init
    
    private init() {
        // Закрытый инициализатор, чтобы предотвратить создание новых экземпляров класса
    }
    
}

// MARK: - Methods

extension AnimationManager {
    
    // Анимируем изменение фонового цвета ячейки при нажатии
    func animateCellWhenSelected(indexPath: IndexPath, tableView: UITableView) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.1, animations: {
            cell?.contentView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 248/255, alpha: 1)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                cell?.contentView.backgroundColor = UIColor(red: 251/255, green: 251/255, blue: 252/255, alpha: 1)
            })
        }
    }
    
}
