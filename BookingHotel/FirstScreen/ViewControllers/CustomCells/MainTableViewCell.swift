//
//  MainTableViewCell.swift
//  BookingHotel
//
//  Created by Yury on 04/09/2023.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    // Массив URL строк для загрузки изображений для слайдера
    var imageUrls: [String] = []
    
    // Создаем новый объект CAShapeLayer, который будет служить маской для слоя
    let maskLayer = CAShapeLayer()
    
    // MARK: - IB Outlets
    
    // Аутлеты для различных UI элементов
    @IBOutlet weak var hotelAdress: UIButton!
    @IBOutlet weak var priceFor: UILabel!
    @IBOutlet weak var minimalPrice: UILabel!
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var ratingNumber: UILabel!
    @IBOutlet weak var ratingText: UILabel!
    @IBOutlet weak var stackViewWithStar: UIStackView!
    @IBOutlet weak var viewWithPagination: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - awakeFromNib
    
    // Метод вызывается после загрузки вью из XIB/Storyboard
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Установка делегата и источника данных для collectionView
        SliderManager.shared.delegate = self
        SliderManager.shared.configureSlider(for: self)
        
        // Настройка вида стек вью с оценкой отеля
        UtilityManager.shared.hotelLevel(stackView: stackViewWithStar)
        
        // Настройка закругления view для пагинации
        UtilityManager.shared.cornerRadius(for: viewWithPagination, radius: 5)
        
        // Регистрация XIB для collectionView
        let nib = UINib(nibName: "MainCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "СollectionViewCell")
        
        // Округление углов collectionView
        UtilityManager.shared.cornerRadius(for: collectionView, radius: 15)
        
        // Настройка вида ячейки
        TableViewManager.shared.setupViewAppearance(customCell: self, shouldApplyCornerRadius: false)
        
        // Устанавливаем созданный CAShapeLayer как маску для текущего слоя.
        self.layer.mask = maskLayer
    }
    
    // MARK: - layoutSubviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Закругляем углы ячейки только снизу
        maskLayer.path = UIBezierPath(roundedRect: self.bounds,
                                      byRoundingCorners: [.bottomLeft, .bottomRight],
                                      cornerRadii: CGSize(width: 15, height: 15)).cgPath
    }
    
    // MARK: - IB Actions
    
    // Метод, вызываемый при нажатии на кнопку адреса отеля
    @IBAction func hotelAdressButttonTapped(_ sender: UIButton) {
        Logger.log("Кнопка \"Адреса отеля\" была нажата, но ничего не происходит согласно тех заданию")
    }
    
}

// MARK:  - Methods

extension MainTableViewCell {
    
    // MARK: Конфигурируем ячейку
    
    func configCell(dataModel: Hotel) {
        ratingText.text = dataModel.ratingName
        ratingNumber.text = String(dataModel.rating)
        hotelName.text = dataModel.name
        hotelAdress.setTitle(dataModel.adress, for: .normal)
        priceFor.text = dataModel.priceForIt
        minimalPrice.text = UtilityManager.shared.formatMinimalPrice(dataModel.minimalPrice)
        
        // Устанавливаем картинки для слайдера
        self.imageUrls = dataModel.imageUrls
        
        // Обновляем делегат и источник данных для collectionView
        SliderManager.shared.delegate = self
        SliderManager.shared.imageUrls = dataModel.imageUrls
        SliderManager.shared.configureSlider(for: self)
        
        pageControl.numberOfPages = imageUrls.count // Обновляем количество страниц для pageControl
        collectionView.reloadData() // Перезагружаем данные коллекции
    }
    
}

// MARK: - Slider Manager Delegate

extension MainTableViewCell: SliderManagerDelegate, ConfigurableCell {
    
    // Метод возвращает массив URL-адресов, которые используются для отображения изображений в слайдере
    func imageUrls(for sliderManager: SliderManager) -> [String] {
        return self.imageUrls
    }
    
}
