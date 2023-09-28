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
    
    @IBOutlet weak var hotelDescription: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var verticalStackView: UIStackView!
    
    // MARK: - awakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Первоначальная настройка UI
        setupUI()
    }
    
}

// MARK: - Methods

extension Main2TableViewCell {
    
    // MARK: Конфигурируем ячейку
    
    func configCell(dataModel: Hotel, indexPath: IndexPath) {
        DynamicCreatingViewManager.shared.configLabelsWithData(with: dataModel.aboutTheHotel.peculiarities, verticalStackView: verticalStackView, customCell: self)
        
        hotelDescription.text = dataModel.aboutTheHotel.description
    }
    
    // Метод для первоначальной настройка UI
    private func setupUI() {
        UIManager.shared.setupNestedTableViewControllerInCell(for: self)
        UIManager.shared.setupViewAppearance(customCell: self)
    }
    
}
