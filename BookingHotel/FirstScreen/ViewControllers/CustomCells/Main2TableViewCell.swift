//
//  Main2TableViewCell.swift
//  BookingHotel
//
//  Created by Yury on 06/09/2023.
//

import UIKit

class Main2TableViewCell: UITableViewCell {
    
    // MARK: - Propeties
    
    // Ссылка на вложенный контроллер таблицы, который будет использоваться в данной ячейке
    var nestedTableViewController: NestedTableViewController?
    
    // MARK: - IB Outlets
    
    // Ссылки на элементы интерфейса, созданные в Interface Builder
    @IBOutlet weak var hotelDescription: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var verticalStackView: UIStackView!
    
    // MARK: - awakeFromNib
    
    // Метод вызывается после загрузки вью из XIB/Storyboard
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Настройка вложенного контроллера таблицы
        TableViewManager.shared.setupNestedTableViewControllerInCell(for: self)
        
        // Настройка внешнего вида ячейки
        TableViewManager.shared.setupViewAppearance(customCell: self)
    }
    
}

// MARK: - Methods

extension Main2TableViewCell {
        
    // MARK: Конфигурируем ячейку
    
    func configCell(dataModel: Hotel, indexPath: IndexPath) {
        DynamicCreatingViewManager.shared.configLabelsWithData(with: dataModel.aboutTheHotel.peculiarities, verticalStackView: verticalStackView, customCell: self)

        hotelDescription.text = dataModel.aboutTheHotel.description
    }
    
}


