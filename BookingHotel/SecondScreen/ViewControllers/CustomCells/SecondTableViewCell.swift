//
//  SecondTableViewCell.swift
//  BookingHotel
//
//  Created by Yury on 09/09/2023.
//

import UIKit

protocol SecondTableViewCellDelegate: AnyObject {
    func chooseRoomButtonTapped(cell: SecondTableViewCell)
    func changeBackButtonTextAndColor()
}

class SecondTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    // Массив URL строк для загрузки изображений для слайдера
    private var imageUrls: [String] = []
    
    // Создаем отдельный экземпляр слайдера
    private let slider = SliderManager()
    
    // Делегат
    weak var delegate: SecondTableViewCellDelegate?
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var chooseRoom: UIButton!
    @IBOutlet weak var includedInPrice: UILabel!
    @IBOutlet weak var minimalPrice: UILabel!
    @IBOutlet weak var moreAboutRoomButton: UIButton!
    @IBOutlet weak var roomDescription: UILabel!
    @IBOutlet weak var viewWithPagination: UIView!
    @IBOutlet weak var pageControl: CustomPageControl!
    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - awakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Первоначальная настройка UI
        UIManager.shared.setupCustomCellForSecondScreen(
            chooseRoomButton: chooseRoom,
            viewWithPagination: viewWithPagination,
            collectionView: collectionView,
            moreAboutRoomButton: moreAboutRoomButton,
            cell: self
        )
        
        // установка target-action для кнопки chooseRoomButtonTapped
        chooseRoom.addTarget(self, action: #selector(chooseRoomButtonAction), for: .touchUpInside)
    }
    
    // MARK: - IB Actions
    
    @IBAction func aboutRoomButtonTapped(_ sender: UIButton) {
        Logger.log("Кнопка \"Подробнее о номере\" была нажата, но ничего не происходит согласно тех заданию")
    }
    
    @IBAction func chooseRoomButtonTapped(_ sender: UIButton) {
        delegate?.chooseRoomButtonTapped(cell: self)
    }
}

// MARK:  - Methods

extension SecondTableViewCell {
    
    // Для таргета кнопки
    @objc func chooseRoomButtonAction() {
        delegate?.changeBackButtonTextAndColor()
    }
    
    // MARK: Конфигурируем ячейку
    
    func configCell(dataModel: Rooms, indexPath: IndexPath, delegate: SecondTableViewCellDelegate) {
        
        self.delegate = delegate
        roomDescription.text = dataModel.rooms[indexPath.section].name
        minimalPrice.text = UtilityManager.shared.formatMinimalPrice(dataModel.rooms[indexPath.section].price)
        includedInPrice.text = dataModel.rooms[indexPath.section].pricePer
        DynamicCreatingViewManager.shared.configLabelsWithData(with: dataModel.rooms[indexPath.section].peculiarities, verticalStackView: verticalStackView, customCell: self)
        
        // Устанавливаем картинки для слайдера
        self.imageUrls = dataModel.rooms[indexPath.section].imageUrls
        
        // Обновляем делегат и источник данных для collectionView
        slider.delegate = self
        slider.imageUrls = dataModel.rooms[indexPath.section].imageUrls
        slider.configureSlider(for: self)
        
        pageControl.numberOfPages = imageUrls.count // Обновляем количество страниц для pageControl
        collectionView.reloadData() // Перезагружаем данные коллекции
    }
    
}

// MARK: - Slider Manager Delegate

extension SecondTableViewCell: SliderManagerDelegate, ConfigurableCell {
        
    // Метод возвращает массив URL-адресов, которые используются для отображения изображений в слайдере
    func imageUrls(for sliderManager: SliderManager) -> [String] {
        return self.imageUrls
    }
    
}
