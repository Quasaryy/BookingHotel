//
//  TableViewCell.swift
//  BookingHotel
//
//  Created by Yury on 09/09/2023.
//

import UIKit

class SecondTableViewCell: UITableViewCell, SliderManagerDelegate, ConfigurableCell {
    
    // MARK: - Properties
    
    // Массив URL строк для загрузки изображений для слайдера
    var imageUrls: [String] = []
    
    // Создаем отдельный экземпляр слайдера
    let slider = SliderManager()
    
    // MARK: - IB Outlets
    
    // Аутлеты для различных UI элементов
    @IBOutlet weak var viewWithPagination: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - awakeFromNib
    
    // Метод вызывается после загрузки вью из XIB/Storyboard
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Настройка вида ячейки
        TableViewManager.shared.setupViewAppearance(customCell: self)
        
        // Регистрация XIB для collectionView
        let nib = UINib(nibName: "SecondCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "СollectionViewCell")
        
        // Настройка закругления view для пагинации
        UtilityManager.shared.cornerRadius(for: viewWithPagination, radius: 5)
        
        // Округление углов collectionView
        UtilityManager.shared.cornerRadius(for: collectionView, radius: 15)
        
        // Настройка вида ячейки
        TableViewManager.shared.setupViewAppearance(customCell: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK:  - Methods

extension SecondTableViewCell {
    
    // MARK: Конфигурируем ячейку
    
    func configCell(dataModel: Rooms, indexPath: IndexPath) {
        
        // Устанавливаем картинки для слайдера
        self.imageUrls = dataModel.rooms[indexPath.section].imageUrls
        
        // Обновляем делегат и источник данных для collectionView
        slider.delegate = self
        slider.imageUrls = dataModel.rooms[indexPath.section].imageUrls
        slider.configureSlider(for: self)
        
        pageControl.numberOfPages = imageUrls.count // Обновляем количество страниц для pageControl
        collectionView.reloadData() // Перезагружаем данные коллекции
    }
    
    
    // MARK: Slider Manager Delegate
    
    func imageUrls(for sliderManager: SliderManager) -> [String] {
        return self.imageUrls
    }
}