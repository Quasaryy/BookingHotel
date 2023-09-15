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
    private var imageUrls: [String] = []
    
    // Создаем новый объект CAShapeLayer, который будет служить маской для слоя
    private let maskLayer = CAShapeLayer()
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var hotelAdress: UIButton!
    @IBOutlet weak var priceFor: UILabel!
    @IBOutlet weak var minimalPrice: UILabel!
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var ratingNumber: UILabel!
    @IBOutlet weak var ratingText: UILabel!
    @IBOutlet weak var stackViewWithStar: UIStackView!
    @IBOutlet weak var viewWithPagination: UIView!
    @IBOutlet weak var pageControl: CustomPageControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - awakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Первоначальная настройка UI
        setupUI()
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
    
    // Метод для первоначальной настройка UI
    private func setupUI() {
        UIManager.shared.setupFirstCustomCellForFirstScreen(customCell: self, shouldApplyCornerRadius: false)
        UIManager.shared.setupCustomCellStackView(stackView: stackViewWithStar)
        UIManager.shared.setupViewWithPaginationCornerRadius(for: viewWithPagination)
        UIManager.shared.setupCollectionViewCornerRadius(for: collectionView)
        UIManager.shared.registerCustomCellNibs(collectionView: collectionView)
        UIManager.shared.setupCustomCellCollectionViewBackgroundColor(collectionView: collectionView, color: .white)
    }
    
}

// MARK: - Slider Manager Delegate

extension MainTableViewCell: SliderManagerDelegate, ConfigurableCell {
    
    // Метод возвращает массив URL-адресов, которые используются для отображения изображений в слайдере
    func imageUrls(for sliderManager: SliderManager) -> [String] {
        return self.imageUrls
    }
    
}
